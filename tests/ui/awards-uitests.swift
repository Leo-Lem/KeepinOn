//	Created by Leopold Lemmermann on 27.11.22.

import XCTest

extension KeepinOnUITests {
  func testClickingAward() {
    tabBar.buttons["Awards"].tap()

    app.buttons["Unlocked award"].tap()

    let button = app.alerts["First Steps (Locked)"].buttons["OK"]
    XCTAssertTrue(button.waitForExistence(timeout: 1), "Alert is not shown.")
    button.tap()
  }

  func testUnlockingAward() {
    // Earning an award
    openTab()
    addProject()
    addItem()

    // validating
    tabBar.buttons["Awards"].tap()
    XCTAssertTrue(app.buttons["Unlocked award"].exists, "Award was not unlocked.")
  }
}
