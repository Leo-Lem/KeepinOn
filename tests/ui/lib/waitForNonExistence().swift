// Created by Leopold Lemmermann on 13.12.22.

extension XCUIElement {
  func waitForNonExistence(timeout: Duration) async -> Bool {
    let now = Date.now
    while  Date.now < now + TimeInterval(timeout.components.seconds) {
      if !self.exists { return true }
      try? await Task.sleep(for: .nanoseconds(1000))
    }
    return false
  }
}
