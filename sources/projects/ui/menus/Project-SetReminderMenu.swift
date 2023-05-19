// Created by Leopold Lemmermann on 20.12.22.

import ComposableArchitecture
import SwiftUI

extension Project {
  struct SetReminderMenu: View {
    let id: Project.ID
    
    var body: some View {
      WithEditableConvertibleViewStore(
        with: id, from: \.privateDatabase.projects, loadWith: .init { .privateDatabase(.projects($0)) }
      ) { editable in
        Unwrap(editable.convertible) { (project: Project) in
          WithViewStore(store, observe: \.notifications.remindersAreAuthorized) { (_: Void) in
            .notifications(.authorizeReminders)
          } content: { reminders in
            Project.Reminder.SelectionMenu(
              Binding { project.reminder } set: { editable.send(.modify(\.reminder, $0)) },
              isAuthorized: reminders.state ?? false
            ) { reminders.send(()) }
          }
        }
      }
    }
    
    @EnvironmentObject private var store: StoreOf<MainReducer>
  }
}
