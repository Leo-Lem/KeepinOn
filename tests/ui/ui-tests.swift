//	Created by Leopold Lemmermann on 26.11.22.

import XCTest

final class KeepinOnUITests: XCTestCase {
  var app = XCUIApplication()

  override func setUpWithError() throws {
    app.launchArguments = ["--under-test"]
    app.launch()
  }

  override func tearDown() {
    app.terminate()
  }
}

extension KeepinOnUITests {
  func testHasAllPages() {}
}
