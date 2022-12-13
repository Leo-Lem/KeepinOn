import AwardsController
import XCTest

class AwardsControllerTests: XCTestCase {
  var service: AwardsController!

  override func setUp() async throws {
    service = await .init()
    #if DEBUG
    service.resetProgress()
    #endif
  }

  func testAwardsAreLoaded() {
    let awards = service.allAwards

    XCTAssertTrue(awards.count > 10, "Less than 10 awards were loaded...")
  }

  func testAwardIsUnlocked() async throws {
    guard
      let award = service.allAwards.first(where: { award in award.id == "First Steps" })
    else { return XCTFail("Tested award does not exist...") }

    XCTAssertFalse(service.unlockedAwards.contains(award), "Award is already unlocked...")

    // this unlocks the award
    try await service.addedItem()

    XCTAssertTrue(service.unlockedAwards.contains(award), "Award is not unlocked...")
  }
}
