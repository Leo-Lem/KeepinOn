//	Created by Leopold Lemmermann on 21.10.22.

protocol AuthService: ObservableService {
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
