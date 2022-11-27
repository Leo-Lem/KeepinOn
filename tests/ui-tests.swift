//	Created by Leopold Lemmermann on 26.11.22.

import XCTest
import Concurrency

final class PortfolioUITests: XCTestCase {
  var app: XCUIApplication!

  override func setUp() {
    app = XCUIApplication()
    app.launchArguments = ["under-test"]
    app.launch()
    
    _ = app.tabs["Home"].waitForExistence(timeout: 15)
  }

  func testAppHas5Tabs() {
    XCTAssertEqual(app.tabBars.buttons.count, 5, "There should be 5 tabs in the app.")
  }

  func testOpenTabAddsProject() {
    app.buttons["Open"].tap()
    XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

    for tapCount in 1 ... 5 {
      app.buttons["Add Project"].tap()
      XCTAssertEqual(app.tables.cells.count, tapCount, "There should be \(tapCount) rows(s) in the list.")
    }
  }

  func testAddingItemInsertsRows() {
    app.buttons["Open"].tap()
    XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

    app.buttons["Add Project"].tap()
    XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a project.")

    for tapCount in 1 ... 5 {
      app.buttons["Add New Item"].tap()
      XCTAssertEqual(
        app.tables.cells.count, tapCount + 1,
        "There should be \(tapCount + 1) list rows after adding an item."
      )
    }
  }
}
