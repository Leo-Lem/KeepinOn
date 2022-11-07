//	Created by Leopold Lemmermann on 28.10.22.

@testable import KeepinOn
import XCTest

final class KOAServiceTests: XCTestCase {
  private var service: KOAService!

  override func setUp() async throws {
    let ckService = await CKService()

    // verifies the user has permissions for writing to the cloudkit database
    guard case .available = ckService.status else {
      throw XCTSkip("Cannot access CloudKit.")
    }

    // cleans up leftover data in the database
    await ckService.deleteAll()

    service = await KOAService(
      keyValueService: UDService(),
      publicDatabaseService: ckService
    )

    // leaving a little time for the serverside actions
    try? await Task.sleep(nanoseconds: 1 * NSEC_PER_SEC)
  }

  func testRegistering() async throws {
    let validCredentials = [
      Credential(userID: " User123", pin: "2345"),
      Credential(userID: "12323", pin: "polol"),
      Credential(userID: "lolol ", pin: "abababa")
    ]

    let invalidCredentials = [
      Credential(userID: "User 123", pin: "1234"),
      Credential(userID: "User123", pin: "0"),
      Credential(userID: "Us", pin: "1234")
    ]

    for credential in validCredentials {
      do { try await service.register(credential) } catch { XCTFail(error.localizedDescription) }
    }

    for credential in invalidCredentials {
      do { try await service.register(credential) } catch { continue }
      XCTFail("\(credential) was falsely accepted.")
    }
  }

  func testLoggingIn() async throws {
    let credential = try await registerExampleUser()

    service.logout()

    do {
      try await service.login(credential)

      guard case .authenticated = service.status else {
        return XCTFail("Authentication was not reflected locally.")
      }
    } catch {
      XCTFail(error.localizedDescription)
    }
  }

  func testUpdatingUser() async throws {
    let credential = Credential.example
    var user = try await service.register(credential)

    user.colorID = .green

    do {
      try await service.update(user)
    } catch {
      XCTFail(error.localizedDescription)
    }
  }

  func testUpdatingCredential() async throws {
    var credential = try await registerExampleUser()

    credential.pin = "NEWPIN"

    do {
      try await service.update(credential)
      service.logout()
      try await service.login(credential)
    } catch {
      XCTFail(error.localizedDescription)
    }
  }

  func testLoggingOut() async throws {
    try await registerExampleUser()

    service.logout()

    guard case .notAuthenticated = service.status else {
      return XCTFail("User was not logged out.")
    }
  }

  func testDeletingAccount() async throws {
    let credential = try await registerExampleUser()

    try await service.deleteAccount()

    do {
      try await service.login(credential)
      XCTFail("Login still worked after deleting.")
    } catch {}
  }
}

private extension KOAServiceTests {
  @discardableResult
  func registerExampleUser() async throws -> Credential {
    let credential = Credential.example
    try await service.register(credential)
    return credential
  }
}
