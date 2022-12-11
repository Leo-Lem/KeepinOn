//	Created by Leopold Lemmermann on 04.12.22.

import DatabaseService
import Errors
import LeosMisc
import MyAuthenticationService

extension AuthenticationStatus {
  var id: String? {
    if case let .authenticated(id) = self { return id } else { return nil }
  }
}

extension MainState {
  @MainActor func setAuthenticationState(for status: AuthenticationStatus) async {
    await printError {
      switch status {
      case .notAuthenticated:
        authenticationState = .notAuthenticated
      case .authenticated:
        try await loadAuthenticationState()
      case .noConnection:
        break
      }
    }
  }

  @MainActor func setAuthenticationState(on event: DatabaseEvent) async {
    await printError {
      for await event in publicDBService.events {
        switch event {
        case let .inserted(type, id) where type == User.self:
          if let id = id as? User.ID, id == authenticationState.id {
            try await loadAuthenticationState()
          }
        case let .deleted(type, id) where type == User.self:
          if let id = id as? User.ID, id == authenticationState.id {
            try authService.logout()
            authenticationState = .notAuthenticated
          }
        case let .status(status):
          if status == .available {
            try await loadAuthenticationState()
          } else if status == .readOnly, case let .authenticated(id) = authService.status {
            authenticationState = .authenticatedWithoutiCloud(id: id)
          }
        case .remote:
          try await loadAuthenticationState()
        default:
          break
        }
      }
    }
  }

  @MainActor private func loadAuthenticationState() async throws {
    if let id = await authenticationState.user?.id ?? authService.status.id {
      switch await publicDBService.status {
      case .available:
        authenticationState = .authenticated(
          user: try await publicDBService.fetch(with: id) ?? (try await publicDBService.insert(User(id: id)))
        )
      case .readOnly:
        authenticationState = .authenticatedWithoutiCloud(id: id)
      default: break
      }
    }
  }
}
