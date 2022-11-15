//	Created by Leopold Lemmermann on 07.11.22.

@testable import KeepinOn
import XCTest

final class KOAwardsServiceTests: XCTestCase {
  private var service: KOAwardsService!

  override func setUp() async throws {
    service = KOAwardsService(
      authService: MockAuthService(),
      keyValueService: MockKVSService()
    )
  }

  func testAwardsAreLoaded() {
    let awards = service.allAwards

    XCTAssertTrue(awards.count > 10, "Less than 10 awards were loaded...")
  }

  func testAwardIsUnlocked() async throws {
    guard
      let award = service.allAwards.first(where: { award in award.id == "First Steps" })
    else { return XCTFail("Tested award does not exist...") }

    XCTAssertFalse(service.isUnlocked(award), "Award is already unlocked...")

    // this unlocks the award
    try await service.addedItem()

    XCTAssertTrue(service.isUnlocked(award), "Award is not unlocked...")
  }
}
