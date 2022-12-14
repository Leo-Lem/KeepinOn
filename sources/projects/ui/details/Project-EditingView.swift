//	Created by Leopold Lemmermann on 09.10.22.

import Colors
import ComposableArchitecture
import Errors
import LeosMisc
import SwiftUI

extension Project {
  func editingView() -> some View { EditingView(self) }

  struct EditingView: View {
    let project: Project

    var body: some View {
      Form {
        Section("") { project.editingMenu(.description) }
        Section("PROJECT_SELECT_COLOR") {
          project.editingMenu(.color)
            .animation(.none, value: project.colorID)
        }
        
        if !project.isClosed {
          Section("PROJECT_REMINDERS") { project.editingMenu(.reminder) }
        }
        
        Section {
          Project.ActionMenu.toggle(project, playsHaptic: true)
          if size == .regular { project.editingMenu(.publish) }
          Project.ActionMenu.delete(project)
        } header: { EmptyView() } footer: { Text("DELETE_PROJECT_WARNING") }
          .buttonStyle(.borderless)
      }
      .formStyle(.grouped)
      .navigationTitle("EDIT_PROJECT")
      .toolbar {
        if size == .compact {
          ToolbarItemGroup(placement: .cancellationAction) { project.editingMenu(.publish) }
        }
      }
#if os(iOS)
      .compactDismissButtonToolbar()
      .embedInNavigationStack()
#endif
      .animation(.default, value: project)
    }
    
    @Environment(\.size) private var size
    
    init(_ project: Project) { self.project = project }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
import Previews

struct ProjectEditingView_Previews: PreviewProvider {
  static var previews: some View {
    Project.EditingView(.example)
      .presentPreview(inContext: true)
  }
}
#endif
