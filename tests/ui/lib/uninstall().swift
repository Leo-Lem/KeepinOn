// Created by Leopold Lemmermann on 13.12.22.

extension XCUIApplication {
  func uninstall(name: String? = nil, timeout: TimeInterval = 5) {
    self.terminate()

    let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")

    let appName = name ??
      (Bundle.main.infoDictionary?["CFBundleName"] as? String)?.replacingOccurrences(of: "UITests-Runner", with: "") ??
      ""

    /// use `firstMatch` because icon may appear in iPad dock
    let appIcon = springboard.icons[appName].firstMatch
    if appIcon.waitForExistence(timeout: timeout) { appIcon.press(forDuration: 2) } else {
      XCTFail("Failed to find app icon named \(appName)")
    }

    let removeAppButton = springboard.buttons["Remove App"]
    if removeAppButton.waitForExistence(timeout: timeout) { removeAppButton.tap() } else {
      XCTFail("Failed to find 'Remove App'")
    }

    let deleteAppButton = springboard.alerts.buttons["Delete App"]
    if deleteAppButton.waitForExistence(timeout: timeout) { deleteAppButton.tap() } else {
      XCTFail("Failed to find 'Delete App'")
    }

    let finalDeleteButton = springboard.alerts.buttons["Delete"]
    if finalDeleteButton.waitForExistence(timeout: timeout) { finalDeleteButton.tap() } else {
      XCTFail("Failed to find 'Delete'")
    }
  }
}
