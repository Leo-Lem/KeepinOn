//	Created by Leopold Lemmermann on 28.11.22.

import Combine
import UIKit

extension WidgetServiceImplementation {
  func resignActivePublisher() -> some Publisher<Notification, Never> {
    NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
  }
}
