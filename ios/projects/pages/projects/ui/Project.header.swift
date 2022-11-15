//	Created by Leopold Lemmermann on 09.10.22.

import SwiftUI

struct ProjectHeader: View {
  let projectWithItems: Project.WithItems,
      editingEnabled: Bool,
      toggleIsClosed: (Project) -> Void,
      delete: (Project) async -> Void

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        HStack {
          Text(project.label)
          SheetLink(.project(projectWithItems)) {
            Label("VIEW_PROJECT_DETAILS", systemImage: "info.bubble")
          }
        }

        ProgressView(value: projectWithItems.progress)
      }

      Spacer()

      Button(
        action: { toggleIsClosed(project) },
        label: {
          project.isClosed ?
            Label("REOPEN_PROJECT", systemImage: "lock.open") :
            Label("CLOSE_PROJECT", systemImage: "lock")
        }
      )

      if editingEnabled {
        SheetLink(.editProject(project)) {
          Label("EDIT_PROJECT", systemImage: "square.and.pencil")
        }

        if isDeleting {
          ProgressView()
        } else {
          Button {
            Task(priority: .userInitiated) {
              isDeleting = true
              await delete(project)
              isDeleting = false
            }
          } label: {
            Label("DELETE_PROJECT", systemImage: "xmark.octagon")
          }
          .tint(.red)
        }
      }
    }
    .labelStyle(.iconOnly)
    .tint(project.color)
    .padding(.bottom, 10)
    .accessibilityElement(children: .combine)
  }

  @State private var isDeleting = false
  
  private var project: Project { projectWithItems.project }

  init(
    _ projectWithItems: Project.WithItems,
    editingEnabled: Bool,
    toggleIsClosed: @escaping (Project) -> Void,
    delete: @escaping (Project) async -> Void
  ) {
    self.projectWithItems = projectWithItems
    self.editingEnabled = editingEnabled
    self.toggleIsClosed = toggleIsClosed
    self.delete = delete
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct ProjectHeader_Previews: PreviewProvider {
    static var previews: some View {
      NavigationStack {
        Form {
          Section {
            Text("some content")
          } header: {
            ProjectHeader(.example, editingEnabled: true) { _ in } delete: { _ in }
          }
        }
      }
      .configureForPreviews()
    }
  }
#endif
