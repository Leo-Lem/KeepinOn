// Created by Leopold Lemmermann on 20.05.23.

import XCTest

final class KeepinOnUITests: XCTestCase {
  private var app: XCUIApplication!

  override func setUp() {
    continueAfterFailure = false

    app = XCUIApplication()
    app.launch()
  }

  override func tearDown() {
    app.terminate()
    app = nil
  }

  func testLaunchPerformance() throws {
    measure(metrics: [XCTApplicationLaunchMetric()]) {
      XCUIApplication().launch()
    }
  }
  
  func test() throws {}
  
}
