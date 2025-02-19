// Created by Leopold Lemmermann on 19.02.25.

import ComposableArchitecture

@Reducer public struct KeepinOn {
  @ObservableState public struct State: Equatable {
    public init() {}
  }

  public enum Action: ViewAction {
    case something

    case view(View)
    public enum View: BindableAction {
      case binding(BindingAction<State>)
      case tap
    }
  }

  public var body: some Reducer<State, Action> {
    Reduce { _, action in
      switch action {
      case .something:
        return .none

      case let .view(action):
        switch action {
        case .binding:
          return .none

        case .tap:
          return .none
        }
      }
    }
  }

  public init() {}
}
