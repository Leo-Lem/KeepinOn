// Created by Leopold Lemmermann on 16.12.22.

import LeosMisc
import SwiftUI

extension Project.Reminder {
  struct SelectionMenu: View {
    @Binding var reminder: Project.Reminder
    let isAuthorized: Bool
    let authorize: () async -> Void
    
    var body: some View {
      OptionalPicker($reminder.animation(), default: .now + 60) { showReminders in
        Toggle("PROJECT_SHOW_REMINDERS", isOn: showReminders)
      } picker: { date, defaultValue in
        DatePicker("PROJECT_REMINDER_TIME", selection: date, in: defaultValue..., displayedComponents: .hourAndMinute)
      }
      .disabled(!isAuthorized, message: "ALLOW_NOTIFICATIONS") {
        Task(priority: .userInitiated) { await authorize() }
      }
      .buttonStyle(.borderless)
    }
    
    init(_ reminder: Binding<Project.Reminder>, isAuthorized: Bool, authorize: @escaping () async -> Void) {
      _reminder = reminder
      (self.isAuthorized, self.authorize) = (isAuthorized, authorize)
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ProjectReminderSelectionMenu_Previews: PreviewProvider {
  static var previews: some View {
    Project.Reminder.SelectionMenu(.constant(nil), isAuthorized: true) {}
      .previewDisplayName("Without selection")
    
    Project.Reminder.SelectionMenu(.constant(.now), isAuthorized: true) {}
      .previewDisplayName("With selection")
    
    Project.Reminder.SelectionMenu(.constant(nil), isAuthorized: false) {}
      .previewDisplayName("Not authorized")
  }
}
#endif
