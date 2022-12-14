// Created by Leopold Lemmermann on 20.12.22.

import ComposableArchitecture

struct PublicDatabase: ReducerProtocol {
  @Dependency(\.publicDatabaseService) private var service
  
  struct State: Equatable {
    var isAvailable: Bool
    var projects: Convertible<SharedProject>.State
    var items: Convertible<SharedItem>.State
    var comments: Convertible<Comment>.State
    var users: Convertible<User>.State
    var friendships: Convertible<Friendship>.State
    
    init(
      databaseIsAvailable: Bool = false,
      projects: [SharedProject] = [],
      items: [SharedItem] = [],
      comments: [Comment] = [],
      users: [User] = [],
      friendships: [Friendship] = []
    ) {
      (self.isAvailable, self.users, self.projects, self.items, self.comments, self.friendships) =
        (databaseIsAvailable, .init(users), .init(projects), .init(items), .init(comments), .init(friendships))
    }
  }
  
  enum Action {
    case setIsAvailable(Bool)
    case projects(Convertible<SharedProject>.Action)
    case items(Convertible<SharedItem>.Action)
    case comments(Convertible<Comment>.Action)
    case users(Convertible<User>.Action)
    case friendships(Convertible<Friendship>.Action)
    case enableUpdates
  }
  
  var body: some ReducerProtocol<State, Action> {
    CombineReducers {
      Reduce { state, action in
        switch action {
        case let .setIsAvailable(isAvailable):
          state.isAvailable = isAvailable
        case .enableUpdates:
          return .run(priority: .userInitiated) { actions in
            await actions.send(.setIsAvailable(service.status == .available))
            
            for await event in service.events {
              if case let .status(status) = event { await actions.send(.setIsAvailable(status == .available)) }
            }
          }
        default: break
        }
        
        return .none
      }
      Scope(state: \.projects, action: /Action.projects) { Convertible<SharedProject>(service: service) }
      Scope(state: \.items, action: /Action.items) { Convertible<SharedItem>(service: service) }
      Scope(state: \.comments, action: /Action.comments) { Convertible<Comment>(service: service) }
      Scope(state: \.users, action: /Action.users) { Convertible<User>(service: service) }
      Scope(state: \.friendships, action: /Action.friendships) { Convertible<Friendship>(service: service) }
    }
  }
}
