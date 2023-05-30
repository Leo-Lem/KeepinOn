// Created by Leopold Lemmermann on 30.05.2023.

import ComposableArchitecture

public struct Projects: ReducerProtocol {
  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    // TODO: add reducer for Projects

    switch action {
    default: break
    }

    return .none
  }

  public init() {}
}

// MARK: - (STATE)

public extension Projects {
  struct State: Equatable {
    // TODO: add state for Projects

    public init() {}
  }
}

// MARK: - (ACTIONS)

public extension Projects {
  enum Action {
    // TODO: add actions for Projects
  }
}
