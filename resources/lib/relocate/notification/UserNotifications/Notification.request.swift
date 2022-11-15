//	Created by Leopold Lemmermann on 20.10.22.

import UserNotifications

extension Notification {
  var request: UNNotificationRequest { UNNotificationRequest(identifier: id, content: content, trigger: trigger) }

  var id: String {
    switch self {
    case .reminder(let project):
      return project.id.uuidString
    }
  }

  var content: UNMutableNotificationContent {
    let content = UNMutableNotificationContent()

    switch self {
    case .reminder(let project):
      content.sound = .default
      content.title = project.title ??? "..."
      if !project.details.isEmpty { content.subtitle = project.details }
    }

    return content
  }

  var trigger: UNCalendarNotificationTrigger {
    switch self {
    case .reminder(let project):
      return UNCalendarNotificationTrigger(
        dateMatching: Calendar.current.dateComponents([.hour, .minute], from: project.reminder ?? .now),
        repeats: true
      )
    }
  }
}
