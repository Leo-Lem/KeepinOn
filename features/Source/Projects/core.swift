// Created by Leopold Lemmermann on 20.02.25.

import ComposableArchitecture
import Data
import EditableProject
import SwiftData

@Reducer public struct Projects {
  @ObservableState public struct State: Equatable, Sendable {
    @SharedReader var projects: [Project]
    var closed: Bool

    var editableProjects: IdentifiedArrayOf<EditableProject.State> {
      get {
        IdentifiedArray(uniqueElements: projects
          .sorted { $0.createdAt! > $1.createdAt! } // TODO: move into SQL
          .map { EditableProject.State($0) })
      }
      set { _ = newValue }
    }

    public init(
      projects: [Project] = [],
      closed: Bool = false
    ) {
      _projects = SharedReader(wrappedValue: projects, .fetchAll(sql: """
          SELECT * FROM project WHERE closed=? ORDER BY createdAt DESC
        """, arguments: [closed])) // order doesnt work
      self.closed = closed
    }
  }

  public enum Action: BindableAction {
    case addProject

    case projects(IdentifiedActionOf<EditableProject>)

    case binding(BindingAction<State>)
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .projects(.element(_, .toggle)):
        return .send(.binding(.set(\.closed, !state.closed)))

      case .addProject:
        var project = Project(title: "", details: "", accent: .green)
        try? database.write { try project.save($0) }
        return .send(.binding(.set(\.closed, false)))

      case .binding(\.closed):
        return .run { [state] _ in
          try? await state.$projects.load(.fetchAll(sql: """
            SELECT * FROM project WHERE closed=?
          """, arguments: [state.closed]))
        }

      case .binding, .projects: return .none
      }
    }
    .forEach(\.editableProjects, action: \.projects) { EditableProject() }
  }

  @Dependency(\.defaultDatabase) var database

  public init() {}
}

public extension Projects.State {
  var canEdit: Bool { !closed }
}
