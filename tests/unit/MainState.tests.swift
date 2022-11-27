//	Created by Leopold Lemmermann on 24.11.22.

@testable import KeepinOn
import XCTest

class MainStateTests: XCTestCase {
  var mainState: MainState!

  override func setUp() async throws {
    mainState = MainState.mock
  }

  func testDidChange() {
    for change in [
      MainState.Change.page(.home),
      .sheet(.project(.example)),
      .banner(.awardEarned(.example)),
      .user(.example),
      .isPremium(true)
    ] {
      let cancellable = mainState.didChange.sink { value in
        XCTAssertEqual(value, change, "The received value does not match.")
      }

      mainState.didChange.send(change)

      cancellable.cancel()
    }
  }
}
