//	Created by Leopold Lemmermann on 27.11.22.

import XCTest

extension KeepinOnUITests {
  func testAddingItemAndShowingItemsInfo() {
    openTab()
    addProject()
    addItem()

    let newItem = collections.buttons["New Item"]
    XCTAssertTrue(newItem.exists, "The item was not created.")
    
    newItem.tap()
    XCTAssertTrue(app.staticTexts["New Item"].waitForExistence(timeout: 1), "Details screen can't be openend.")
  }

  func testCompletingAndUncompletingItem() {
    openTab()
    addProject()
    addItem()
    
    collections.buttons["New Item"].swipeRight()
    collections.buttons["Complete"].tap()
    
    XCTAssertTrue(app.buttons["completed"].exists, "The item was not completed.")
    
    collections.buttons["completed"].swipeRight()
    collections.buttons["Incomplete"].tap()
    
    XCTAssertTrue(app.buttons["New Item"].exists, "The item was not uncompleted.")
  }

  func testEditingItem() {
    openTab()
    addProject()
    addItem()
    
    collections.buttons["New Item"].swipeLeft()
    collections.buttons["Edit"].tap()
    
    let textField = app.textFields["Item Name"]
    XCTAssertTrue(textField.waitForExistence(timeout: 1), "Edit item view cannot be openend.")
  }

  func testDeletingItem() {
    openTab()
    addProject()
    addItem()
    
    collections.buttons["New Item"].swipeLeft()
    collections.buttons["Delete"].tap()
    
    XCTAssertFalse(collections.buttons["New Item"].exists, "Edit item view cannot be openend.")
  }
}
