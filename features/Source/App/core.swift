// Created by Leopold Lemmermann on 19.02.25.

import ComposableArchitecture
import Data
import Featured
import Projects

@Reducer public struct KeepinOn {
  @ObservableState public struct State: Equatable {
    public var projects: Projects.State
    @Presents public var featured: Featured.State?

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
    case featured(PresentationAction<Featured.Action>)

    case toggleFeatured(Bool)

    case binding(BindingAction<State>)
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()

    Scope(state: \.projects, action: \.projects) { Projects() }

    Reduce { state, action in
      switch action {
      case let .toggleFeatured(newValue):
        state.featured = newValue ? Featured.State() : nil
        return .none

      case .projects, .featured, .binding: return .none
      }
    }
    .ifLet(\.$featured, action: \.featured) { Featured() }
  }

  public init() {}
}
