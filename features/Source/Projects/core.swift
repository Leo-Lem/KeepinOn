// Created by Leopold Lemmermann on 20.02.25.

import ComposableArchitecture
import Data
import EditableProject
import SwiftData

@Reducer public struct Projects {
  @ObservableState public struct State: Equatable {
    var projects: IdentifiedArrayOf<EditableProject.State>
    var closed: Bool

    public init(
      projects: [Project] = [],
      closed: Bool = false
    ) {
      self.projects = IdentifiedArrayOf<EditableProject.State>(uniqueElements: projects.map(EditableProject.State.init))
      self.closed = closed
    }
  }

  public enum Action: ViewAction {
    case fetchProjects
    case addProjects([Project])

    case projects(IdentifiedActionOf<EditableProject>)

    case view(View)
    public enum View: BindableAction {
      case binding(BindingAction<State>)
      case appear
      case addProject
      case addItem(to: EditableProject.State)
    }
  }

  public var body: some Reducer<State, Action> {
    BindingReducer(action: \.view)

    Reduce { state, action in
      switch action {
      case let .addProjects(projects):
        state.projects.append(contentsOf: projects.map(EditableProject.State.init))
        return .none

      case let .projects(.element(id, action)):
        switch action {
        case .delete:
          state.projects.remove(id: id)
          return .none

        case .toggle:
          state.closed.toggle()
          return .none

        case .alert: return .none
        }

//      case let .removeItem(item):
//        state.projects
//          .first { $0.id == item.project?.id }?
//          .project
//          .items
//          .removeAll { $0.id == item.id }
//        return .none

      case .fetchProjects:
        return .run { @MainActor [fetch] send in
          let projects = try await fetch(FetchDescriptor<Project>())
          send(.addProjects(projects))
        }

      case let .view(action):
        switch action {
        case .appear:
          return .send(.fetchProjects)

        case .addProject:
          let project = Project(title: "", details: "", accent: .green)
          state.projects.append(EditableProject.State(project))
          state.closed = false
          return .run { @MainActor [insert] _ in
            try await insert(project)
          }

        case let .addItem(project):
          let item = Item(title: "", details: "", project: project.project)
          state.projects.first { $0.id == project.id}?.project.items.append(item)
          return .run { @MainActor [insertItem] _ in
            try await insertItem(item)
          }

        case .binding: return .none
        }
      }
    }
    .forEach(\.projects, action: \.projects, element: EditableProject.init)
  }

  @Dependency(\.projects.fetch) var fetch
  @Dependency(\.projects.insert) var insert
  @Dependency(\.items.insert) var insertItem

  public init() {}
}

public extension Projects.State {
  var canEdit: Bool { !closed }
  var filtered: IdentifiedArrayOf<EditableProject.State> { projects.filter { $0.project.closed == closed } }
}
