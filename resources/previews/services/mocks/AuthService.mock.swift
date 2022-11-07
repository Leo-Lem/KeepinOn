//	Created by Leopold Lemmermann on 21.10.22.

import Combine

final class MockAuthService: AuthService {
  let didChange = PassthroughSubject<Void, Never>()

  var status: AuthStatus = .notAuthenticated

  func register(_ credential: Credential) async throws -> User {
    print("Registered user with \(credential).")
    return try await login(credential)
  }

  func login(_ credential: Credential) async throws -> User {
    let user = User(id: credential.id)
    status = .authenticated(user)
    print("Logged user in with \(credential).")
    return user
  }

  func update(_ user: User) async throws -> User {
    print("Updated user \(user).")
    return user
  }

  func update(_ credential: Credential) async throws -> Credential {
    print("Updated credential \(credential).")
    return credential
  }

  func logout() {
    status = .notAuthenticated
    print("Logged user out.")
  }

  func deleteAccount() async throws {
    print("Deleted user's account.")
  }
}
