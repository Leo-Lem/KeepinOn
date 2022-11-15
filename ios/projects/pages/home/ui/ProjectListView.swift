//	Created by Leopold Lemmermann on 07.11.22.

import SwiftUI

extension HomeView {
  struct ProjectListView: View {
    let projectsWithItems: [Project.WithItems],
        edit: (Project) -> Void,
        show: (Project.WithItems) -> Void

    var body: some View {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHGrid(rows: [GridItem(.fixed(100))]) {
          ForEach(projectsWithItems) { projectWithItems in
            Project.Card(projectWithItems)
              .contextMenu {
                Button(
                  action: { edit(projectWithItems.project) },
                  label: { Label("EDIT_PROJECT", systemImage: "square.and.pencil") }
                )

                Button(
                  action: { show(projectWithItems) },
                  label: { Label("SHOW_PROJECT_DETAILS", systemImage: "info.bubble") }
                )
              }
          }
          .padding()
        }
        .fixedSize(horizontal: false, vertical: true)
      }
    }

    init(
      _ projectsWithItems: [Project.WithItems],
      edit: @escaping (Project) -> Void,
      show: @escaping (Project.WithItems) -> Void
    ) {
      self.projectsWithItems = projectsWithItems
      self.edit = edit
      self.show = show
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
      Form {
        Section("1 Project") {
          HomeView.ProjectListView(
            [Project.WithItems.example]
          ) { _ in } show: { _ in }
        }

        Section("3 Projects") {
          HomeView.ProjectListView(
            [
              Project.WithItems.example,
              Project.WithItems.example,
              Project.WithItems.example
            ]
          ) { _ in } show: { _ in }
        }

        Section("No Projects") {
          HomeView.ProjectListView([]) { _ in } show: { _ in }
        }
      }
      .formStyle(.columns)
      .padding()
      .configureForPreviews()
    }
  }
#endif
