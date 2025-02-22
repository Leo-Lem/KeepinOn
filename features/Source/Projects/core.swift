// Created by Leopold Lemmermann on 20.02.25.

import ComposableArchitecture
import Data
import EditableProject
import SwiftData

@Reducer public struct Projects {
  @ObservableState public struct State: Equatable {
    @SharedReader public var projects: [Project]
    public var editableProjects: IdentifiedArrayOf<EditableProject.State>
    public var closed: Bool

    public init(
      projects: [Project] = [],
      closed: Bool = false
    ) {
      _projects = SharedReader(value: projects)
      editableProjects = []
      self.closed = closed
    }
  }

  public enum Action: BindableAction {
    case addProject

    case editableProjects(IdentifiedActionOf<EditableProject>)
    case appear
    case projects([Project])
    case loadProjects

    case binding(BindingAction<State>)
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .editableProjects(.element(_, .toggle)):
        return .send(.binding(.set(\.closed, !state.closed)))

      case .addProject:
        var project = Project(title: "", details: "", accent: .green)
        try? database.write { try project.save($0) }
        return .send(.binding(.set(\.closed, false)))

      case .binding(\.closed):
        return .send(.loadProjects)

      case .loadProjects:
        return .run { [projects = state.$projects, closed = state.closed] _ in
          try? await projects.load(.fetchAll(sql: """
            SELECT * FROM project WHERE closed=? ORDER BY createdAt DESC
          """, arguments: [closed]))
        }

      case let .projects(projects):
        state.editableProjects = IdentifiedArray(uniqueElements: projects.map { EditableProject.State($0) })
        return .merge(
          state.editableProjects.ids.map { .send(.editableProjects(.element(id: $0, action: .appear)))}
        )

      case .appear:
        return .merge(
          .publisher { state.$projects.publisher.map { .projects($0) } },
          .send(.loadProjects)
        )

      case .binding, .editableProjects: return .none
      }
    }
    .forEach(\.editableProjects, action: \.editableProjects, element: EditableProject.init)
  }

  @Dependency(\.defaultDatabase) var database

  public init() {}
}
