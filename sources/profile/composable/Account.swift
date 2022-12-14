// Created by Leopold Lemmermann on 20.12.22.

import ComposableArchitecture
import LeosMisc
import Queries

// TODO: add awards

struct Account: ReducerProtocol {
  @Dependency(\.authenticationService) private var authService
  
  struct State: Equatable {
    var id: User.ID?
    var publicDatabase: PublicDatabase.State
    
    init(id: User.ID?, publicDatabase: PublicDatabase.State) {
      (self.id, self.publicDatabase) = (id, publicDatabase)
    }
  }
  
  enum Action {
    case setID(User.ID?), loadID
    case publicDatabase(PublicDatabase.Action)
    // TODO: move user into optional feature (when id is not nil)
    case loadUser, addUser, modifyUser(modification: (inout User) -> Void), deleteUser
    // TODO: move friends into optional feature (when id is not nil)
    case loadFriends, loadFriendship(userID: User.ID)
    case addFriend(id: User.ID), removeFriend(id: User.ID)
    case logout, deleteAccount
    case enableUpdates
  }
  
  // swiftlint:disable:next cyclomatic_complexity
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case let .setID(id):
      state.id = id
      return .task { .loadUser }
      
    case .loadID:
      if case let .authenticated(id) = authService.status {
        return .task { .setID(id) }
      } else {
        return .task { .setID(nil) }
      }
      
    case .loadUser:
      if let id = state.id { return .task { .publicDatabase(.users(.loadWith(id: id))) } }
      
    case .addUser:
      if let id = state.id { return .task { .publicDatabase(.users(.add(User(id: id)))) } }
      
    case let .modifyUser(modification):
      if let id = state.id {
        return .task { .publicDatabase(.users(.modifyWith(id: id, modification: modification))) }
      }
      
    case .deleteUser:
      if let id = state.id { return .task { .publicDatabase(.users(.deleteWith(id: id))) } }
      
    case .publicDatabase:
      return Scope(state: \.publicDatabase, action: /Action.publicDatabase, PublicDatabase.init)
        .reduce(into: &state, action: action)
      
    case .logout:
      return .fireAndForget { try authService.logout() }

    case .deleteAccount:
      return .run { actions in
        await actions.send(.deleteUser)
        await actions.send(.loadID)
      }
      
    case .loadFriends:
      if let currentUserID = state.id {
        return .run { actions in
          for keyPath in [\Friendship.sender, \.receiver] {
            await actions.send(.publicDatabase(.friendships(.loadFor(
              query: Query(.init(keyPath, currentUserID), .init(\.accepted, true), compound: .and)
            ))))
          }
        }
      }
      
    case let .loadFriendship(userID):
      if let currentUserID = state.id {
        return .run { actions in
          for id in [Friendship.ID(currentUserID, userID), Friendship.ID(userID, currentUserID)] {
            await actions.send(.publicDatabase(.friendships(.loadWith(id: id))))
          }
        }
      }
      
    case let .addFriend(friendID):
      if let currentUserID = state.id {
        if let request = state.publicDatabase.friendships.convertible(with: .init(friendID, currentUserID)) {
          return .task { .publicDatabase(.friendships(.modifyWith(id: request.id) { $0.accepted = true })) }
        } else {
          return .task { .publicDatabase(.friendships(.add(Friendship(currentUserID, friendID)))) }
        }
      }
      
    case let .removeFriend(friendID):
      if let currentUserID = state.id {
        return .run { actions in
          for id in [Friendship.ID(currentUserID, friendID), .init(friendID, currentUserID)] {
            await actions.send(.publicDatabase(.friendships(.deleteWith(id: id))))
          }
        }
      }
      
    case .enableUpdates:
      return .run(priority: .background) { actions in
        for await event in authService.events {
          await actions.send(.loadID)
          if case .registered = event { await actions.send(.addUser) }
        }
      }
    }
    
    return .none
  }
}

extension Account.State {
  var canPublish: Bool { publicDatabase.isAvailable && id != nil }
  var user: User? { id.flatMap(publicDatabase.users.convertible) }
  var progress: Award.Progress? { user?.progress }
  func friendship(for id: User.ID) -> Friendship? {
    publicDatabase.friendships.convertibles(matching: Query(\.sender, id)).first ??
      publicDatabase.friendships.convertibles(matching: Query(\.receiver, id)).first
  }
}
