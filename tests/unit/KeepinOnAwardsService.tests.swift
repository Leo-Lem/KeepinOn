//	Created by Leopold Lemmermann on 07.11.22.

@testable import KeepinOn
import XCTest

class AwardsServiceTests<S: AwardsService>: XCTestCase {
  var service: S!

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

  func testDidChange() {
    for change in [
      AwardsChange.unlocked(.example),
      .progress(.itemsAdded(1)),
      .progress(.commentsPosted(1)),
      .progress(.itemsCompleted(1)),
      .progress(.unlockedFullVersion)
    ] {
      let cancellable = service.didChange.sink { value in
        XCTAssertEqual(value, change, "The received value does not match.")
      }

      service.didChange.send(change)

      cancellable.cancel()
    }
  }
}

class KeepinOnAwardsServiceTests: AwardsServiceTests<AwardsServiceImplementation> {
  override func setUp() async throws {
    service = AwardsServiceImplementation(.mock)
    service.resetProgress()
  }
}
