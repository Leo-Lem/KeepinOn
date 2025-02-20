// Created by Leopold Lemmermann on 20.02.25.

import ComposableArchitecture
import Data

@Reducer public struct EditableProject {
  @ObservableState public struct State: Equatable, Identifiable {
    public var project: Project

    public var id: PersistentIdentifier { project.id }

    public init(project: Project) { self.project = project }
  }

  public enum Action {
    case delete
    case toggle
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .delete:
        return .run { [delete, project = state.project] _ in
          try await delete(project)
        }

      case .toggle:
        state.project.closed.toggle()
        return .none
      }
    }
  }

  @Dependency(\.projects.delete) var delete

  public init() {}
}
