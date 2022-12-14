//	Created by Leopold Lemmermann on 09.10.22.

import Concurrency
import CoreDataService
import CoreHapticsService
import Errors
import LeosMisc
import Previews
import PushNotificationService
import SwiftUI

extension Project {
  func editingView() -> some View { EditingView(self) }

  struct EditingView: View {
    var body: some View {
      Form {
        Section("PROJECT_SETTINGS") {
          TextField("PROJECT_NAME_PLACEHOLDER", text: $project.title)
            .accessibilityLabel("A11Y_EDIT_PROJECT_NAME")
            .accessibilityIdentifier("edit-project-name")

          TextField("PROJECT_DESCRIPTION_PLACEHOLDER", text: $project.details)
            .accessibilityLabel("A11Y_EDIT_PROJECT_DESCRIPTION")
            .accessibilityIdentifier("edit-project-description")
        }

        Section("PROJECT_SELECT_COLOR") {
          $project.colorID.selectionGrid
            .accessibilityLabel("PROJECT_SELECT_COLOR")
        }

        if !project.isClosed {
          Section("PROJECT_REMINDERS") {
            OptionalPicker($project.reminder.animation(), default: .now + 60) { showReminders in
              Toggle("PROJECT_SHOW_REMINDERS", isOn: showReminders)
            } picker: { date, defaultValue in
              DatePicker(
                "PROJECT_REMINDER_TIME", selection: date, in: defaultValue..., displayedComponents: .hourAndMinute
              )
              .accessibilityElement(children: .combine)
            }
            .disabled(!(projectsController.canSendReminders ?? false), message: "ALLOW_NOTIFICATIONS") {
              Task(priority: .userInitiated) {
                if projectsController.canSendReminders == nil {
                  await projectsController.notificationService.authorize()
                } else { openSystemSettings() }
              }
            }
            .buttonStyle(.borderless)
          }
        }

        Section {
          #if os(iOS)
          closeProjectButton()
          project.deleteButton(dismissOnDelete: true)
          #elseif os(macOS)
          VStack {
            HStack {
              closeProjectButton().frame(maxWidth: .infinity)
              Divider()
              project.deleteButton(dismissOnDelete: true).frame(maxWidth: .infinity)
            }
            Divider()
            HStack {
              project.publishingMenu().frame(maxWidth: .infinity)
            }
          }
          .buttonStyle(.borderless)
          #endif
        } header: { Text("") } footer: { Text("DELETE_PROJECT_WARNING") }
      }
      .formStyle(.grouped)
      .navigationTitle("EDIT_PROJECT")
      #if os(iOS)
        .toolbar {
          ToolbarItemGroup(placement: .cancellationAction, content: project.publishingMenu)

          ToolbarItem(placement: .confirmationAction) {
            saveButton()
              .buttonStyle(.borderedProminent)
              .accessibilityIdentifier("save-project")
          }
        }
        .compactDismissButtonToolbar()
        .embedInNavigationStack()
      #elseif os(macOS)
        .onChange(of: project) { _ in
          Task(priority: .userInitiated) { await updateProject() }
        }
      #endif
    }

    @State private var project: Project

    @Environment(\.dismiss) private var dismiss

    @State private var hapticsService = CoreHapticsService()
    @EnvironmentObject private var projectsController: ProjectsController

    init(_ project: Project) { _project = State(initialValue: project) }
  }
}

private extension Project.EditingView {
  func closeProjectButton() -> some View {
    AsyncButton(indicatorStyle: .edge(.trailing), taskPriority: .userInitiated) {
      await printError {
        try await projectsController.databaseService.modify(Project.self, with: project.id) { mutable in
          mutable.isClosed.toggle()
        }
      }
      hapticsService?.play(.taDa)
      dismiss()
      // navigate to closed view
    } label: { Label("CLOSE_PROJECT", systemImage: "lock.open") }
  }

  #if os(iOS)
  func saveButton() -> some View {
    AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
      await updateProject()
      dismiss()
    } label: { Text("SAVE") }
  }
  #endif

  @MainActor func updateProject() async {
    await printError {
      try await projectsController.databaseService.insert(project)

      if project.reminder != nil {
        await projectsController.notificationService.schedule(KeepinOnNotification.reminder(project))
      } else {
        projectsController.notificationService.cancel(KeepinOnNotification.reminder(project))
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ProjectEditingView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Project.EditingView(.example)

      #if os(iOS)
      Project.example.editingView()
        .previewInSheet()
      #endif
    }
  }
}
#endif
