// Created by Leopold Lemmermann on 19.02.25.

import ComposableArchitecture
import Data
import Featured
import Projects

@Reducer public struct KeepinOn {
  @ObservableState public struct State: Equatable {
    public var projects: Projects.State
    public var featured: Featured.State

    public init(
      projects: Projects.State = Projects.State(),
      featured: Featured.State = Featured.State()
    ) {
      self.projects = projects
      self.featured = featured
    }
  }

  public enum Action: BindableAction {
    case projects(Projects.Action)
    case featured(Featured.Action)

    case binding(BindingAction<State>)
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()

    Scope(state: \.featured, action: \.featured, child: Featured.init)
    Scope(state: \.projects, action: \.projects, child: Projects.init)

    Reduce { _, action in
      switch action {
      case .projects, .featured, .binding: return .none
      }
    }
  }

  public init() {}
}
