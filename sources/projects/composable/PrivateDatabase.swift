// Created by Leopold Lemmermann on 20.12.22.

import ComposableArchitecture

struct PrivateDatabase: ReducerProtocol {
  @Dependency(\.privateDatabaseService) private var service
  @Dependency(\.indexingService) private var indexingService
  
  struct State: Equatable {
    var projects: Convertible<Project>.State
    var items: Convertible<Item>.State
    
    init(projects: [Project] = [], items: [Item] = []) {
      (self.projects, self.items) = (.init(projects), .init(items))
    }
  }
  
  enum Action {
    case projects(Convertible<Project>.Action)
    case items(Convertible<Item>.Action)
    case enableIndexing
  }
  
  var body: some ReducerProtocol<State, Action> {
    CombineReducers {
      enableIndexingReducer
      Scope(state: \.projects, action: /Action.projects) { Convertible<Project>(service: service) }
      Scope(state: \.items, action: /Action.items) { Convertible<Item>(service: service) }
    }
  }
  
  private var enableIndexingReducer: some ReducerProtocol<State, Action> {
    Reduce { _, action in
      if case .enableIndexing = action {
        return .fireAndForget {
          _ = service.handleEventsTask { event in
            switch event {
            case let .inserted(type, id) where type == Project.self:
              if let id = id as? Project.ID, let project: Project = try await service.fetch(with: id) {
                try await indexingService.updateReference(to: project)
              }
              
            case let .inserted(type, id) where type == Item.self:
              if let id = id as? Item.ID, let item: Item = try await service.fetch(with: id) {
                try await indexingService.updateReference(to: item)
              }
              
            case let .deleted(_, id):
              try await indexingService.removeReference(with: id.description)
              
            default: break
            }
          }
        }
      }
      
      return .none
    }
  }
}
