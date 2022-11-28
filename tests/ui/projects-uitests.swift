//	Created by Leopold Lemmermann on 27.11.22.

import XCTest

extension KeepinOnUITests {
  func testCreatingProjectAndShowingProjectInfo() {
    openTab()
    addProject()
    
    XCTAssertTrue(collections.staticTexts["New Project"].exists, "The project was not created.")

    collections.buttons["SHOW DETAILS"].tap()

    XCTAssertTrue(app.staticTexts["New Project"].exists, "Project details cannot be opened.")
  }

  func testOpeningAndClosingProject() {
    openTab()
    addProject()

    collections.buttons["CLOSE THIS PROJECT"].tap()
    tabBar.buttons["Closed"].tap()
    collections.buttons["REOPEN THIS PROJECT"].tap()
    tabBar.buttons["Open"].tap()

    XCTAssertTrue(collections.staticTexts["New Project"].exists, "The project is not in the open tab.")
  }

  func testEditingProject() {
    openTab()
    addProject()

    collections.buttons["EDIT PROJECT"].tap() // open edit project

    XCTAssertTrue(app.staticTexts["Edit Project"].exists, "Cannot open edit page.")
    
    collections.textFields["Project name"].tap()
    collections.textFields["Project name"].typeText("HELLO")
    app.navigationBars["Edit Project"].buttons["Save"].tap() // Save the project
                
    XCTAssertTrue(collections.staticTexts["HELLO"].waitForExistence(timeout: 10), "The project was not edited")
  }

  func testDeletingProject() {
    openTab()
    addProject()

    collections.buttons["DELETE THIS PROJECT"].tap()
    app.alerts["DELETE PROJECT?"].scrollViews.otherElements.buttons["DELETE"].tap()
    
    XCTAssertTrue(
      app.staticTexts["No Projects to see here."].waitForExistence(timeout: 5),
      "The project was not deleted."
    )
  }
}
