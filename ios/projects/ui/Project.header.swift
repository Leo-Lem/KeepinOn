//	Created by Leopold Lemmermann on 09.10.22.

import SwiftUI

struct ProjectHeader: View {
  let project: Project,
      editingEnabled: Bool,
      toggleIsClosed: (Project) -> Void,
      delete: (Project) async -> Void

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        HStack {
          Text(project.label)
          SheetLink(.project(project)) {
            Label("VIEW_PROJECT_DETAILS", systemImage: "info.bubble")
          }
        }

        ProgressView(value: project.progress)
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

  init(
    _ project: Project,
    editingEnabled: Bool,
    toggleIsClosed: @escaping (Project) -> Void,
    delete: @escaping (Project) async -> Void
  ) {
    self.project = project
    self.editingEnabled = editingEnabled
    self.toggleIsClosed = toggleIsClosed
    self.delete = delete
  }
}

// MARK: - (Previews)

struct ProjectHeader_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      Form {
        Section {
          Text("some content")
        } header: {
          ProjectHeader(.init(
            title: "Open Project",
            isClosed: false,
            colorID: .gold
          ), editingEnabled: true) { _ in } delete: {_ in}
        }

        Section {
          Text("some content")
        } header: {
          ProjectHeader(.init(
            title: "Closed Project",
            isClosed: true,
            colorID: .green,
            items: [.init(isDone: true)]
          ), editingEnabled: false) { _ in } delete: {_ in}
        }
      }
    }
    .configureForPreviews()
  }
}
