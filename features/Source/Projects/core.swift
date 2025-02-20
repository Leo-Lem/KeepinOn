// Created by Leopold Lemmermann on 20.02.25.

import ComposableArchitecture
import Data
import SwiftData

@Reducer public struct Projects {
  @ObservableState public struct State: Equatable {
    var projects: [Project]
    var closed: Bool
    var sorting: PartialKeyPath<Project>

    public init(
      projects: [Project] = [],
      closed: Bool = false,
      sorting: PartialKeyPath<Project> = \.createdAt
    ) {
      self.projects = projects
      self.closed = closed
      self.sorting = sorting
    }
  }

  public enum Action: ViewAction {
    case fetchProjects
    case setProjects([Project])

    case view(View)
    public enum View: BindableAction {
      case binding(BindingAction<State>)
      case appear
    }
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .setProjects(projects):
        state.projects = projects
        return .none

      case .fetchProjects:
        return .run { @MainActor send in
          @Dependency(\.projects.fetch) var fetch
          let projects = try await fetch(FetchDescriptor<Project>())
          send(.setProjects(projects))
        }

      case let .view(action):
        switch action {
        case .appear:
          return .send(.fetchProjects)

        case .binding:
          return .none
        }
      }
    }
  }

  public init() {}
}
