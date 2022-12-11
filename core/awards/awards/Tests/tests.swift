import AwardsService
import XCTest

open class AwardsServiceTests<S: AwardsService>: XCTestCase {
  public var service: S!

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
      AwardsEvent.unlocked(.example),
      .progress(.addedItems()),
      .progress(.completedItems()),
      .progress(.postedComments()),
      .progress(.becamePremium)
    ] {
      let cancellable = service.eventPublisher.sink { value in
        XCTAssertEqual(value, change, "The received value does not match.")
      }

      service.eventPublisher.send(change)

      cancellable.cancel()
    }
  }
}

final class AwardsServiceImplTests: AwardsServiceTests<AwardsServiceImpl> {
  override func setUp() {
    service = AwardsServiceImpl()
    #if DEBUG
    service.resetProgress()
    #endif
  }
}
