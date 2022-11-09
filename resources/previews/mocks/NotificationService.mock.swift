//	Created by Leopold Lemmermann on 20.10.22.

import Combine

final class MockNotificationService: NotificationService {
  let didChange = PassthroughSubject<Void, Never>()

  var isAuthorized = true

  func schedule(_ notification: Notification) {
    if isAuthorized {
      print("Notification (\(notification)) scheduled!")
    } else {
      print("Not authorized!")
    }
  }

  func cancel(_ notification: Notification) {
    print("Notification (\(notification)) canceled!")
  }
}
