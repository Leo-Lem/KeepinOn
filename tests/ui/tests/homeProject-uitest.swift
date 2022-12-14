// Created by Leopold Lemmermann on 13.12.22.

extension KeepinOnUITests {
  func testHomeProject() {
    openHomePage()
    
    // add project
    addFirstProject()
    XCTAssertTrue(featuredProjectsList.exists)
    
    // project info
    firstProjectCard.tap()
    XCTAssertTrue(app.staticTexts["project-detail-page-header"].exists)
    dismissPopover()
  }
}
