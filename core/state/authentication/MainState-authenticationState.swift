// Created by Leopold Lemmermann on 08.12.22.

extension MainState {
  enum AuthenticationState: Equatable {
    case notAuthenticated,
         authenticatedWithoutiCloud(id: User.ID),
         authenticated(user: User)
    
    var user: User? {
      if case let .authenticated(user) = self { return user } else { return nil }
    }
    
    var id: User.ID? {
      switch self {
      case let .authenticatedWithoutiCloud(id): return id
      case let .authenticated(user): return user.id
      default: return nil
      }
    }
    
    var hasiCloud: Bool {
      if case .authenticated = self { return true } else { return false }
    }
  }
}
