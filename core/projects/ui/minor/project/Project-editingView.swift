//	Created by Leopold Lemmermann on 09.10.22.

import Concurrency
import Errors
import LeosMisc
import Previews
import PushNotificationService
import SwiftUI

extension Project {
  func editingView() -> some View { EditingView(self) }

  struct EditingView: View {
    var body: some View {
      NavigationStack {
        Form {
          Section("PROJECT_SETTINGS") {
            TextField("PROJECT_NAME_PLACEHOLDER", text: $project.title)
              .accessibilityLabel("A11Y_EDIT_PROJECT_NAME")
            TextField("PROJECT_DESCRIPTION_PLACEHOLDER", text: $project.details)
              .accessibilityLabel("A11Y_EDIT_PROJECT_DESCRIPTION")
          }

          Section("PROJECT_SELECT_COLOR") {
            $project.colorID.selectionGrid
              .accessibilityLabel("PROJECT_SELECT_COLOR")
          }

          if !project.isClosed {
            Section("PROJECT_REMINDERS") {
              OptionalPicker($project.reminder.animation(), default: .now + 60) {
                Toggle("PROJECT_SHOW_REMINDERS", isOn: $0)
              } picker: {
                DatePicker("PROJECT_REMINDER_TIME", selection: $0, in: $1..., displayedComponents: .hourAndMinute)
                  .accessibilityElement(children: .combine)
              }
              .disabled(!canSendReminders, message: "ALLOW_NOTIFICATIONS") { openSettings() }
            }
          }

          Section {
            Button(project.isClosed ? "REOPEN_PROJECT" : "CLOSE_PROJECT", action: toggleIsClosed)
            Button("DELETE_PROJECT", role: .destructive) { isDeleting = true }
              .deleteProjectAlert(isDeleting: $isDeleting) { await deleteProject() }
          } footer: { Text("DELETE_PROJECT_WARNING") }
        }
        .toolbar {
          project.publishingMenu()
          saveButton()
          
          #if os(iOS)
          if vSize == .compact {
            ToolbarItem(placement: .cancellationAction) {
              Button("CANCEL") { dismiss() }
                .buttonStyle(.borderedProminent)
            }
          }
          #endif
        }
        .navigationTitle("EDIT_PROJECT")
        .task {
          canSendReminders = mainState.notificationService.isAuthorized ?? false
          tasks.add(mainState.notificationService.didChange.getTask(operation: updateCanSendReminders))
        }
        .buttonStyle(.borderless) // for runtime warnings
      }
    }

    @EnvironmentObject private var mainState: MainState
    @Environment(\.dismiss) private var dismiss
    
    #if os(iOS)
    @Environment(\.verticalSizeClass) var vSize
    #endif
    
    @State private var project: Project
    @State private var isDeleting = false
    @State private var canSendReminders = false

    private let tasks = Tasks()

    init(_ project: Project) { _project = State(initialValue: project) }
  }
}

private extension Project.EditingView {
  func saveButton() -> some ToolbarContent {
    ToolbarItem(placement: .confirmationAction) {
      Button("SAVE") { updateProject() }
        .buttonStyle(.borderedProminent)
    }
  }
}

private extension Project.EditingView {
  func toggleIsClosed() {
    project.isClosed.toggle()
    if project.isClosed { mainState.hapticsService?.play(.taDa) }
    mainState.didChange.send(.page(project.isClosed ? .closed : .open))
  }

  func updateProject() {
    printError { try mainState.localDBService.insert(project) }

    if project.reminder != nil {
      Task(priority: .userInitiated) {
        await mainState.notificationService.schedule(KeepinOnNotification.reminder(project))
      }
    } else {
      mainState.notificationService.cancel(KeepinOnNotification.reminder(project))
    }

    dismiss()
  }

  func deleteProject() async {
    await printError {
      try await mainState.displayError {
        if (try? await mainState.remoteDBService.exists(with: project.id, SharedProject.self)) ?? false {
          try await mainState.remoteDBService.unpublish(with: project.id, SharedProject.self)
        }
      }

      try mainState.localDBService.delete(project)
      for itemID in project.items { try mainState.localDBService.delete(with: itemID, Item.self) }

      dismiss()
    }
  }

  func updateCanSendReminders(_ change: PushNotificationChange) {
    if case let .authorization(isAuthorized) = change { canSendReminders = isAuthorized }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct EditingProject_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        Project.EditingView(.example)
          .previewDisplayName("Bare")

        Project.example.editingView()
          .previewInSheet()
      }
      .configureForPreviews()
    }
  }
#endif
