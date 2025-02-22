// Created by Leopold Lemmermann on 19.02.25.

import ComposableArchitecture
import Data
import Projects

@Reducer public struct KeepinOn {
  @ObservableState public struct State: Equatable {
    public var projects: Projects.State
    public var itemDetail: Item?

    public init(
      projects: Projects.State = Projects.State()
    ) {
      self.projects = projects
    }
  }

  public enum Action: BindableAction {
    case projects(Projects.Action)

    case binding(BindingAction<State>)
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()

    Scope(state: \.projects, action: \.projects, child: Projects.init)

    Reduce { state, action in
      switch action {
      case let .projects(.editableProjects(.element(projectIndex, .editableItems(.element(itemIndex, .detail))))):
        return .send(.binding(.set(
          \.itemDetail,
           state.projects.editableProjects[id: projectIndex]?.editableItems[id: itemIndex]?.item
        )))

      case .projects, .binding: return .none
      }
    }
  }

  public init() {}
}
