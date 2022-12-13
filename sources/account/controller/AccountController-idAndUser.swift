// Created by Leopold Lemmermann on 13.12.22.

import AuthenticationService
import Errors

extension AccountController {
  @inlinable func getID() -> User.ID? {
    if case let .authenticated(id) = authService.status { return id } else { return nil }
  }

  func setIDAndUser(on event: AuthenticationEvent) async {
    await printError {
      switch event {
      case .registered, .loggedIn:
        id = getID()
        user = try await getUser(for: id)
      case .loggedOut:
        id = nil
        user = nil
      case .deregistered:
        try await id.flatMap { id in try await databaseService.delete(User.self, with: id) }
        user = nil
        id = nil
      default:
        break
      }
    }
  }
}
