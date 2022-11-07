//	Created by Leopold Lemmermann on 09.10.22.

import SwiftUI

struct EditProjectView: View {
  var body: some View {
    NavigationStack {
      Form {
        Section("GENERIC_SETTINGS") {
          TextField("PROJECT_NAME_PLACEHOLDER", text: $vm.title)
          TextField("PROJECT_DESCRIPTION_PLACEHOLDER", text: $vm.details)
        }

        Section("PROJECT_SELECT_COLOR") {
          SelectColorGrid(colorID: $vm.colorID)
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
          Button("DELETE_PROJECT", role: .destructive) {
            vm.requestDeletingProject()
          }
        } footer: {
          Text("DELETE_PROJECT_WARNING")
        }
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
      .styledNavigationTitle("EDIT_PROJECT")
    }
  }

  @StateObject private var vm: ViewModel

  init(_ project: Project, appState: AppState) {
    _vm = StateObject(wrappedValue: ViewModel(project, appState: appState))
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct EditProjectView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      EditProjectView(.example, appState: .example)
        .previewDisplayName("Bare")

      SheetView.Preview {
        EditProjectView(.example, appState: .example)
      }
      .previewDisplayName("Sheet")
    }
    .configureForPreviews()
  }
}
#endif
