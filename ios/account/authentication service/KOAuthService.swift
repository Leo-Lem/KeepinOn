//	Created by Leopold Lemmermann on 28.10.22.

import Combine

final class KOAuthService: AuthService {
  let didChange = PassthroughSubject<Void, Never>()
  private(set) var status: AuthStatus = .notAuthenticated {
    didSet { didChange.send() }
  }

  private let keyValueService: KeyValueService,
              publicDatabaseService: PublicDatabaseService

  init(
    keyValueService: KeyValueService,
    publicDatabaseService: PublicDatabaseService
  ) async {
    self.keyValueService = keyValueService
    self.publicDatabaseService = publicDatabaseService

    await printError(loginWithLocalCredential)
  }

  @discardableResult
  func register(_ credential: Credential) async throws -> User {
    try await mapLoginAndRegistrationError {
      try await mapCloudError {
        try await validate(credential)
        let user = try await createUser(for: credential)

        status = .authenticated(user)
        save(credential: credential)
        return user
      }
    }
  }

  @discardableResult
  func login(_ credential: Credential) async throws -> User {
    return try await mapLoginAndRegistrationError {
      try await mapCloudError {
        try await check(credential)
        if let user = try await getUser(with: credential) {
          status = .authenticated(user)
          save(credential: credential)
          return user
        } else {
          throw AuthError.noConnection
        }
      }
    }
  }

  @discardableResult
  func update(_ user: User) async throws -> User {
    try await executeIfAuthenticated { _ in
      try await mapCloudError {
        let user = try await publicDatabaseService.publish(user)
        status = .authenticated(user)
        return user
      }
    }
  }

  @discardableResult
  func update(_ credential: Credential) async throws -> Credential {
    try await executeIfAuthenticated { _ in
      try await mapCloudError {
        save(credential: credential)
        return try await publicDatabaseService.publish(credential)
      }
    }
  }

  func logout() {
    deleteCredential()
    status = .notAuthenticated
  }

  func deleteAccount() async throws {
    try await executeIfAuthenticated { user in
      try await mapCloudError {
        logout()
        try await publicDatabaseService.unpublish(user)
        try await publicDatabaseService.unpublish(Credential(userID: user.id, pin: ""))
      }
    }
  }
}

private extension KOAuthService {
  func loginWithLocalCredential() async throws {
    if let credential = readCredential() {
      let user = try await login(credential)
      status = .authenticated(user)
    }
  }

  func validate(_ credential: Credential) async throws {
    try await validate(userID: credential.userID)
    if let pin = credential.pin {
      try validate(pin: pin)
    }
  }

  @discardableResult
  func createUser(for credential: Credential) async throws -> User {
    let user = User(id: credential.userID)

    try await publicDatabaseService.publish(user)
    try await publicDatabaseService.publish(credential)

    return user
  }

  func check(_ credential: Credential) async throws {
    guard let actualCredential: Credential = try await publicDatabaseService.fetch(with: credential.id) else {
      throw AuthError.LoginError.unknownID(id: credential.userID)
    }
    guard actualCredential.pin == credential.pin else {
      throw AuthError.LoginError.wrongPIN
    }
  }

  func getUser(with credential: Credential) async throws -> User? {
    return try await publicDatabaseService.fetch(with: credential.userID)
  }

  func validate(userID: String) async throws {
    if try await isTaken(id: userID) {
      throw AuthError.RegError.invalidID(reason: .isTaken)
    } else if containsUnsupportedChars(id: userID) {
      throw AuthError.RegError.invalidID(reason: .unsupportedChars)
    } else if userID.count < 3 {
      throw AuthError.RegError.invalidID(reason: .tooShort)
    }
  }

  func validate(pin: String) throws {
    if pin.count < 4 {
      throw AuthError.RegError.invalidPin(reason: .tooShort)
    }
  }

  func isTaken(id: String) async throws -> Bool {
    try await publicDatabaseService.exists(with: id)
  }

  func containsUnsupportedChars(id: String) -> Bool {
    for char: Character in [" "] where id.contains(char) {
      return true
    }

    return false
  }
}

// MARK: persisting credentials

private extension KOAuthService {
  static let userIDKey = "user.id"
  static let userPinKey = "user.pin"
  static let pinlessKey = "user.pinless"

  func save(credential: Credential) {
    printError {
      try keyValueService.insert(credential.id, for: Self.userIDKey)
      if let pin = credential.pin {
        try keyValueService.insert(pin, for: Self.userPinKey)
      } else {
        try keyValueService.insert(true, for: Self.pinlessKey)
      }
    }
  }

  func readCredential() -> Credential? {
    printError {
      if let id: String = try keyValueService.load(for: Self.userIDKey) {
        if let pinless: Bool = try keyValueService.load(for: Self.pinlessKey), pinless {
          return Credential(id: id, pin: nil)
        } else if let pin: String = try keyValueService.load(for: Self.userPinKey) {
          return Credential(id: id, pin: pin)
        }
      }

      return nil
    }
  }

  func deleteCredential() {
    printError {
      try keyValueService.delete(for: Self.userIDKey)
      try keyValueService.delete(for: Self.userPinKey)
    }
  }
}

// MARK: Error Handling

private extension KOAuthService {
  func executeIfAuthenticated<T>(_ action: (User) async throws -> T) async throws -> T {
    guard case let .authenticated(user) = status else { throw AuthError.notAuthenticated }

    return try await action(user)
  }

  func mapLoginAndRegistrationError<T>(_ action: () async throws -> T) async rethrows -> T {
    do {
      return try await action()
    } catch let error as AuthError.RegError {
      throw AuthError.registration(error)
    } catch let error as AuthError.LoginError {
      throw AuthError.login(error)
    } catch {
      throw error
    }
  }

  func mapCloudError<T>(_ action: () async throws -> T) async rethrows -> T {
    do {
      return try await action()
    } catch let error as PublicDatabaseError {
      if case let .userRelevant(reason) = error, reason == .notAuthenticated {
        throw AuthError.noCloudKitPermissions
      } else {
        throw AuthError.noConnection
      }
    } catch {
      throw error
    }
  }
}
