//	Created by Leopold Lemmermann on 26.11.22.

@_exported import XCTest

@MainActor final class KeepinOnUITests: XCTestCase {
  var app = XCUIApplication()

  @MainActor override func setUp() async throws {
    app.launchArguments = ["--test"]
    app.launch()
    
    guard await app.progressIndicators["app-is-loading-indicator"].waitForNonExistence(timeout: .seconds(30)) else {
      throw XCTSkip("App is inaccessible.")
    }
    
    if app.windows.firstMatch.horizontalSizeClass == .regular {
      XCUIDevice.shared.orientation = .landscapeLeft // to get the navigationBar to be visible
    }
  }

  override func tearDown() {
    app.terminate()
  }
}
