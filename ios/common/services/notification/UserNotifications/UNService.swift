//	Created by Leopold Lemmermann on 20.10.22.

import Combine
import UIKit
import UserNotifications

final class UNService: NotificationService {
  let didChange = PassthroughSubject<Void, Never>()
  private(set) var isAuthorized: Bool = false

  private let tasks = Tasks()

  init() async {
    isAuthorized = await authorize()
    tasks.add(hookIntoUpdates())
  }

  func schedule(_ notification: Notification) {
    center.add(notification.request)
  }

  func cancel(_ notification: Notification) {
    center.removePendingNotificationRequests(withIdentifiers: [notification.id])
  }
}

private extension UNService {
  var center: UNUserNotificationCenter { .current() }

  func authorize() async -> Bool {
    switch await center.notificationSettings().authorizationStatus {
    case .authorized:
      return true
    case .notDetermined:
      let result = try? await center.requestAuthorization(options: [.alert, .sound])
      return result ?? false
    case .denied, .ephemeral, .provisional:
      return false
    @unknown default:
      return false
    }
  }

  func hookIntoUpdates() -> Task<Void, Never> {
    NotificationCenter.default
      .publisher(for: UIApplication.didBecomeActiveNotification)
      .getTask { [unowned self] _ in
        self.isAuthorized = await self.authorize()
        self.didChange.send()
      }
  }
}
