//	Created by Leopold Lemmermann on 20.10.22.

import PushNotificationService
import Foundation
import LeosMisc

enum KeepinOnNotification: PushNotification {
  case reminder(Project)
  
  var id: UUID {
    switch self {
    case .reminder(let project):
      return project.id
    }
  }
  
  var title: String {
    switch self {
    case .reminder(let project):
      return project.title ??? "..."
    }
  }
  
  var subtitle: String? {
    switch self {
    case .reminder(let project):
      return project.details ??? "..."
    }
  }
  
  var scheduleFor: Date {
    switch self {
    case .reminder(let project):
      return project.reminder ?? .now
    }
  }
}
