// Created by Leopold Lemmermann on 13.12.22.

extension KeepinOnUITests {
  var featuredProjectsList: XCUIElement { app.scrollViews["featured-projects-list"].firstMatch }
  var firstProjectCard: XCUIElement { featuredProjectsList.descendants(matching: .button).firstMatch }
  var projectsList: XCUIElement { app.collectionViews["projects-list"].firstMatch }
  var firstProject: XCUIElement { projectsList.cells.element(boundBy: 0) }
  var firstItem: XCUIElement { projectsList.cells.element(boundBy: 1) }
  
  func openHomePage() { app.buttons["select-home-page"].tap() }
  func openOpenPage() { app.buttons["select-open-page"].tap() }
  func openClosedPage() { app.buttons["select-closed-page"].tap() }
  
  func addFirstProject() { app.buttons["add-first-project"].tap() }
  func addProject() { app.buttons["add-project"].tap() }
  func addProjectAndItem() {
    addProject()
    projectsList.buttons["add-item"].firstMatch.tap()
  }
  
  func dismissPopover() {
    if app.otherElements["PopoverDismissRegion"].firstMatch.waitForExistence(timeout: 1) {
      app.otherElements["PopoverDismissRegion"].firstMatch.tap()
    } else {
      app.swipeDown(velocity: .fast)
    }
  }
}
