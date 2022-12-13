// Created by Leopold Lemmermann on 12.12.22.

extension KeepinOnUITests {
  func testProject() async {
    openOpenPage()
    
    // adding project
    addProject()
    XCTAssertTrue(firstProject.exists)
    
    // showing project details
    firstProject.buttons["show-project-details"].tap()
    XCTAssertTrue(app.staticTexts["project-detail-page-header"].exists)
    dismissPopover()
    
    // toggling closed and open
    firstProject.buttons["toggle-project"].tap()
    openClosedPage()
    XCTAssertTrue(firstProject.exists)
    
    firstProject.buttons["toggle-project"].tap()
    openOpenPage()
    XCTAssertTrue(firstProject.exists)
    
    // editing project
    firstProject.buttons["edit-project"].tap()
    XCTAssertTrue(app.textFields["edit-project-name"].exists)
    let name = "My Project No. 1"
    let nameField = app.textFields["edit-project-name"]
    nameField.tap()
    nameField.typeText(name)
    app.buttons["save-project"].firstMatch.tap()
    
    firstProject.buttons["show-project-details"].tap()
    XCTAssertTrue(app.staticTexts[name].exists)
    dismissPopover()
    
    // deleting project
    firstProject.buttons["delete-project"].tap()
    app.alerts.firstMatch.buttons.element(boundBy: 1).tap()
    let projectDoesNotExist = await firstProject.waitForNonExistence(timeout: .seconds(1))
    XCTAssertTrue(projectDoesNotExist)
  }
}
