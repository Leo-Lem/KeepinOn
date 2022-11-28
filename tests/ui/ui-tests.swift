//	Created by Leopold Lemmermann on 26.11.22.

import XCTest

final class KeepinOnUITests: XCTestCase {
  let app = XCUIApplication()

  override func setUpWithError() throws {
    app.launchArguments = ["under-test"]
    app.launch()

    if !tabBar.buttons["Home"].waitForExistence(timeout: 10) { throw XCTSkip("App is inaccessible.") }
  }
}

extension KeepinOnUITests {
  func testHas5Tabs() {
    XCTAssertEqual(app.tabBars.buttons.count, 5, "There should be 5 tabs in the app.")
  }
}

// MARK: - (HELPERS)

extension KeepinOnUITests {
  func openTab() { tabBar.buttons["Open"].tap() }
  func addProject() { app.navigationBars["Open"].buttons["Add Project"].tap() }
  func addItem() { collections.buttons["Add New Item"].tap() }
  
  var collections: XCUIElementQuery { app.collectionViews }
  var tabBar: XCUIElement { app.tabBars["Tab Bar"] }
  
  func login() {
    app.navigationBars["Community"].buttons["Your Account"].tap()
    XCTAssertTrue(
      app.otherElements["<Anonymous> (User ID: @UITESTS)"].waitForExistence(timeout: 1),
      "Editing account is not available."
    )
  }
  func publish() {}
}
