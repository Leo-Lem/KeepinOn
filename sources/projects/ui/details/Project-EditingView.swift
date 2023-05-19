//	Created by Leopold Lemmermann on 09.10.22.

import LeosMisc
import SwiftUI

extension Project {
  struct EditingView: View {
    let id: Project.ID

    var body: some View {
      WithConvertibleViewStore(
        with: id, from: \.privateDatabase.projects, loadWith: .init { .privateDatabase(.projects($0)) }
      ) { project in
        Unwrap(project, content: Render.init)
      }
    }
    
    struct Render: View {
      let project: Project
      
      var body: some View {
        Form {
          Section("") { Project.EditDescriptionMenu(id: project.id)}
          Section("PROJECT_SELECT_COLOR") { Project.PickColorMenu(id: project.id) }
          if !project.isClosed { Section("PROJECT_REMINDERS") { Project.SetReminderMenu(id: project.id) } }
          
          Section {
            Project.ToggleMenu(id: project.id, feedback: [.haptic, .changePage, .dismiss])
            if size == .regular { Project.PublishMenu(id: project.id) }
            Project.DeleteMenu(id: project.id)
          } header: { EmptyView() } footer: { Text("DELETE_PROJECT_WARNING") }
            .buttonStyle(.borderless)
        }
        .formStyle(.grouped)
        .navigationTitle("EDIT_PROJECT")
        .toolbar {
          if size == .compact {
            ToolbarItemGroup(placement: .cancellationAction) { Project.PublishMenu(id: project.id) }
          }
        }
#if os(iOS)
        .compactDismissButtonToolbar()
        .embedInNavigationStack()
#endif
        .animation(.default, value: project)
      }
      
      @Environment(\.size) private var size
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
import Previews

struct ProjectEditingView_Previews: PreviewProvider {
  static var previews: some View {
    Project.EditingView.Render(project: .example)
      .presentPreview(inContext: true)
  }
}
#endif
