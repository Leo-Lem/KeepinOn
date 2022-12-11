//	Created by Leopold Lemmermann on 24.11.22.

import AwardsService
@testable import KeepinOn
import XCTest

class MainStateTests: XCTestCase {
  var mainState: MainState!

  override func setUp() async throws { mainState = await MainState.mock }
}
