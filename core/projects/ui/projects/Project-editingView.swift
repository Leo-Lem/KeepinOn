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
            .disabled(!(canSendReminders ?? false), message: "ALLOW_NOTIFICATIONS") {
              Task(priority: .userInitiated) {
                if canSendReminders == nil {
                  await mainState.notificationService.authorize()
                } else { openSystemSettings() }
              }
            }
            .buttonStyle(.borderless)
          }
        }

        Section {
          #if os(iOS)
          closeProjectButton()
          deleteProjectButton()
          #elseif os(macOS)
          VStack {
            HStack {
              closeProjectButton().frame(maxWidth: .infinity)
              Divider()
              deleteProjectButton().frame(maxWidth: .infinity)
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
        .onChange(of: project) { project in
          Task(priority: .userInitiated) { await mainState.updateProject(project) }
        }
      #endif
        .animation(.default, value: canSendReminders)
        .onAppear {
          canSendReminders = mainState.notificationService.isAuthorized
          tasks["updateCanSendReminders"] = Task(priority: .background) {
            for await event in mainState.notificationService.events {
              if case let .authorization(isAuthorized) = event { canSendReminders = isAuthorized }
            }
          }
        }
    }

    @State private var project: Project
    @State private var canSendReminders: Bool? = false

    @State private var tasks = Tasks()
    @State private var hapticsService = CoreHapticsService()

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var mainState: MainState

    init(_ project: Project) { _project = State(initialValue: project) }
  }
}

private extension Project.EditingView {
  func deleteProjectButton() -> some View {
    AsyncButton(indicatorStyle: .edge(.trailing), taskPriority: .userInitiated) {
      await mainState.showPresentationAndAwaitDismiss(alert: .deleteProject(project))

      Task {
        await mainState.privateDBService.handleEvents { event in
          if case let .deleted(type, id) = event, type == Project.self, id as? Project.ID == project.id {
            dismiss()
          }
        }
      }
    } label: { Label("DELETE_PROJECT", systemImage: "bin.xmark") }
      .foregroundColor(.red)
  }

  func closeProjectButton() -> some View {
    AsyncButton(indicatorStyle: .edge(.trailing), taskPriority: .userInitiated) {
      dismiss()
      await mainState.toggleProjectIsClosed(project)
      hapticsService?.play(.taDa)
      mainState.showPresentation(.closed)
    } label: { Label("CLOSE_PROJECT", systemImage: "lock.open") }
  }

  #if os(iOS)
  func saveButton() -> some View {
    AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
      await mainState.updateProject(project)
      dismiss()
    } label: {
      Text("SAVE")
    }
  }
  #endif
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
    .configureForPreviews()
  }
}
#endif
