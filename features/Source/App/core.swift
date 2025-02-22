// Created by Leopold Lemmermann on 19.02.25.

import ComposableArchitecture
import Data
import Projects

@Reducer public struct KeepinOn {
  @ObservableState public struct State: Equatable {
    var projects: Projects.State

    public init(
      projects: Projects.State = Projects.State()
    ) {
      self.projects = projects
    }
  }

  public enum Action {
    case projects(Projects.Action)
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.projects, action: \.projects, child: Projects.init)

    Reduce { _, action in
      switch action {
      case .projects: return .none
      }
    }
  }

  public init() {}
}
