//	Created by Leopold Lemmermann on 28.11.22.

import Combine
import AppKit

extension WidgetServiceImplementation {
  func resignActivePublisher() -> some Publisher<Notification, Never> {
    NotificationCenter.default.publisher(for: NSApplication.willResignActiveNotification)
  }
}
