// Created by Leopold Lemmermann on 20.02.25.

import ComposableArchitecture
import Data

@Reducer public struct EditableProject {
  @ObservableState public struct State: Equatable, Identifiable {
    public var project: Project

    @Presents public var alert: AlertState<Action.Alert>?

    public var id: PersistentIdentifier { project.id }

    public init(_ project: Project) { self.project = project }
  }

  public enum Action {
    case toggle
    case delete

    case alert(PresentationAction<Alert>)
    public enum Alert: Equatable {
      case delete
    }
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .alert(action):
        return if case .presented(.delete) = action {
          .run { [delete, project = state.project] _ in
            try await delete(project)
          }
        } else {
          .none
        }

      case .delete:
        state.alert = AlertState {
          TextState("DELETE_PROJECT_ALERT_TITLE")
        } actions: {
          ButtonState(role: .destructive, action: .send(.delete)) {
            TextState("DELETE")
          }
        }
        return .none

      case .toggle:
        state.project.closed.toggle()
        return .none
      }
    }
  }

  @Dependency(\.projects.delete) var delete

  public init() {}
}
