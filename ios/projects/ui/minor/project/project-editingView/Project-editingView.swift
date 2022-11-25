//	Created by Leopold Lemmermann on 09.10.22.

import AuthenticationService
import LeosMisc
import Previews
import SwiftUI

extension Project {
  func editingView() -> some View { EditingView(self) }
  
  struct EditingView: View {
    @EnvironmentObject private var state: MainState
    @Environment(\.dismiss) private var dismiss
    let project: Project

    var body: some View {
      Content()
        .awaitSetup {
          await Project.EditingView.ViewModel(project, dismiss: dismiss.callAsFunction, mainState: state)
        }
    }

    init(_ project: Project) { self.project = project }

    struct Content: View {
      @EnvironmentObject var vm: Project.EditingView.ViewModel

      var body: some View {
        NavigationStack {
          Form {
            Section("GENERIC_SETTINGS") {
              TextField("PROJECT_NAME_PLACEHOLDER", text: $vm.title)
              TextField("PROJECT_DESCRIPTION_PLACEHOLDER", text: $vm.details)
            }

            Section("PROJECT_SELECT_COLOR") {
              $vm.colorID.selectionGrid
            }

            if !vm.isClosed && vm.canSendReminders {
              Section("PROJECT_REMINDERS") {
                OptionalPicker($vm.reminder.animation(), default: .now + 60) {
                  Toggle("PROJECT_SHOW_REMINDERS", isOn: $0)
                } picker: {
                  DatePicker("PROJECT_REMINDER_TIME", selection: $0, in: $1..., displayedComponents: .hourAndMinute)
                }
              }
            }

            Section {
              Button(vm.isClosed ? "REOPEN_PROJECT" : "CLOSE_PROJECT") {
                vm.toggleIsClosed()
              }
              Button("DELETE_PROJECT", role: .destructive) { vm.isDeleting = true }
                .deleteProjectAlert(isDeleting: $vm.isDeleting) { await vm.deleteProject() }
            } footer: {
              Text("DELETE_PROJECT_WARNING")
            }
            .buttonStyle(.borderless)
          }
          .toolbar {
            PublishingMenu(isPublished: vm.isPublished) {
              Task(priority: .userInitiated) { await vm.publishProject() }
            } unpublish: {
              Task(priority: .userInitiated) { await vm.unpublishProject() }
            }

            ToolbarItem(placement: .confirmationAction) {
              Button("GENERIC_SAVE") { vm.updateProject() }
                .buttonStyle(.borderedProminent)
            }
          }
          .title("EDIT_PROJECT")
          .if(vm.remoteDBService.status == .available) { $0
            .sheet(isPresented: $vm.isAuthenticating) { AuthenticationView(service: vm.authService) }
          } else: { $0
            .alert("CANT_CONNECT_TO_ICLOUD_TITLE", isPresented: $vm.isAuthenticating) {} message: {
              Text("CANT_CONNECT_TO_ICLOUD_MESSAGE")
            }
          }
        }
      }
    }
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
