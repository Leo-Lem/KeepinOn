// Created by Leopold Lemmermann on 13.12.22.

extension KeepinOnUITests {
  func testInAppPurchase() {
    openOpenPage()
    for _ in 0 ..< 3 { addProject() }
    
    addProject()
    let button = app.buttons["iap-popover"].firstMatch
    XCTAssertTrue(button.exists)
    button.tap()
  }
}
