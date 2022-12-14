// Created by Leopold Lemmermann on 13.12.22.

import Foundation
import PushNotificationService

extension ProjectsController {
  func getCanSendReminders() -> Bool? { notificationService.isAuthorized }
  func setCanSendReminders(on event: NotificationEvent) {
    if case let .authorization(isAuthorized) = event { canSendReminders = isAuthorized }
  }
}
