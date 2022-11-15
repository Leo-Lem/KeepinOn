//	Created by Leopold Lemmermann on 21.10.22.

import Combine

protocol AuthService {
  var didChange: PassthroughSubject<Void, Never> { get }
  
  var status: AuthStatus { get }

  @discardableResult
  func register(_ credential: Credential) async throws -> User

  @discardableResult
  func login(_ credential: Credential) async throws -> User

  @discardableResult
  func update(_ user: User) async throws -> User

  @discardableResult
  func update(_ credential: Credential) async throws -> Credential

  func logout()
  func deleteAccount() async throws
}
