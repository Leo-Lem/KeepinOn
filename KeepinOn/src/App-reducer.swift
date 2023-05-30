// Created by Leopold Lemmermann on 30.05.2023.

import ComposableArchitecture
import struct Projects.Projects

struct AppReducer: ReducerProtocol {
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.projects, action: /Action.projects, child: Projects.init)

    Reduce { state, action in
      switch action {
      // TODO: add reducers
      default: break
      }

      return .none
    }
  }
}

// MARK: - (STATE)

extension AppReducer {
  struct State: Equatable {
    var projects = Projects.State()
    // TODO: add state
  }
}

// MARK: - (ACTIONS)

extension AppReducer {
  enum Action {
    case projects(Projects.Action)
    // TODO: add actions
  }
}
