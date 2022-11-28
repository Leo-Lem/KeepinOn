//	Created by Leopold Lemmermann on 09.10.22.

import Concurrency
import Errors
import RemoteDatabaseService
import SwiftUI

extension Project {
  func headerView(canEdit: Bool) -> some View { HeaderView(self, canEdit: canEdit) }

  struct HeaderView: View {
    let project: Project,
        canEdit: Bool

    var body: some View {
      HStack {
        VStack(alignment: .leading) {
          HStack {
            Text(project.label)
              .lineLimit(1)

            Button { showInfo() } label: {
              Label("SHOW_PROJECT_DETAILS", systemImage: "info.bubble")
            }
          }

          ProgressView(value: items.progress)
        }

        Spacer()

        Button(action: toggleIsClosed) {
          project.isClosed ?
            Label("REOPEN_PROJECT", systemImage: "lock.open") :
            Label("CLOSE_PROJECT", systemImage: "lock")
        }

        if canEdit {
          Button(action: showEdit) {
            Label("EDIT_PROJECT", systemImage: "square.and.pencil")
          }

          Button { isDeleting = true } label: {
            Label("DELETE_PROJECT", systemImage: "xmark.octagon")
          }
          .tint(.red)
          .if(isDeleting) { $0
            .hidden()
            .overlay(content: ProgressView.init)
          }
          .deleteProjectAlert(isDeleting: $isDeleting) {
            await delete()
            isDeleting = false
          }
        }
      }
      .labelStyle(.iconOnly)
      .tint(project.color)
      .padding(.bottom, 10)
      .animation(.default, value: isDeleting)
      .accessibilityElement(children: .contain)
      .accessibilityLabel(project.a11y(items))
    }

    @EnvironmentObject private var mainState: MainState
    @Environment(\.dismiss) private var dismiss

    @State private var isDeleting = false

    init(_ project: Project, canEdit: Bool) {
      self.project = project
      self.canEdit = canEdit
    }
  }
}

private extension Project.HeaderView {
  var items: [Item] {
    printError {
      try mainState.displayError {
        try project.items.compactMap(mainState.localDBService.fetch)
      }
    } ?? []
  }

  func showInfo() {
    mainState.didChange.send(.sheet(.project(project)))
  }

  func showEdit() {
    mainState.didChange.send(.sheet(.editProject(project)))
  }

  func delete() async {
    await printError {
      try await mainState.displayError {
        if (try? await mainState.remoteDBService.exists(with: project.id, SharedProject.self)) ?? false {
          try await mainState.remoteDBService.unpublish(with: project.id, SharedProject.self)
        }
      }

      try mainState.localDBService.delete(project)

      for item: Item in try project.items.compactMap(mainState.localDBService.fetch) {
        try mainState.localDBService.delete(item)
      }

      dismiss()
    }
  }

  func toggleIsClosed() {
    printError {
      var project = project
      project.isClosed.toggle()
      try mainState.localDBService.insert(project)
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct ProjectHeader_Previews: PreviewProvider {
    static var previews: some View {
      NavigationStack {
        Form {
          Section {
            Text("some content (can edit)")
          } header: {
            Project.HeaderView(.example, canEdit: true)
          }

          Section {
            Text("some more content (cannot edit)")
          } header: {
            Project.example.headerView(canEdit: false)
          }
        }
      }
      .configureForPreviews()
    }
  }
#endif
