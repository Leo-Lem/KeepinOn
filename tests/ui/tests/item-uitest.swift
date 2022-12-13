// Created by Leopold Lemmermann on 13.12.22.

extension KeepinOnUITests {
  func testItem() async {
    openOpenPage()
    
    // adding item
    addProjectAndItem()
    XCTAssertTrue(firstItem.exists)
    
    // showing details
    if app.windows.firstMatch.horizontalSizeClass == .regular {
      firstItem.tap()
      XCTAssertTrue(app.staticTexts["item-detail-page-header"].exists)
      dismissPopover()
    } else {
      #warning("popover cannot be dismissed in compact size layout.")
    }
    
    // completing item
    firstItem.swipeRight()
    projectsList.buttons["toggle-item"].tap()
    
    // editing item
    firstItem.swipeLeft()
    projectsList.buttons["edit-item"].tap()
    let itemNameField = app.textFields["edit-item-name"]
    itemNameField.tap()
    let name = "My Item No. 1"
    itemNameField.typeText(name)
    app.buttons["save-item"].firstMatch.tap()
    XCTAssertTrue(app.staticTexts[name].exists)
    
    // deleting item
    firstItem.swipeLeft()
    projectsList.buttons["delete-item"].tap()
    let itemDoesNotExist = await app.staticTexts[name].waitForNonExistence(timeout: .seconds(1))
    XCTAssertTrue(itemDoesNotExist)
  }
}
