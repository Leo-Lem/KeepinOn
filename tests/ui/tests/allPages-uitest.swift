// Created by Leopold Lemmermann on 13.12.22.

extension KeepinOnUITests {
  func testHasAllPages() {
    for id in ["home", "open", "closed", "awards", "community"].map({ "select-\($0)-page" }) {
      XCTAssertTrue(app.buttons[id].exists)
    }
  }
}
