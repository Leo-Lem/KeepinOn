//	Created by Leopold Lemmermann on 07.11.22.

import SwiftUI

extension HomeView {
  struct ProjectListView: View {
    let projects: [Project],
        edit: (Project) -> Void,
        show: (Project) -> Void

    var body: some View {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHGrid(rows: [GridItem(.fixed(100))]) {
          ForEach(projects) { project in
            ProjectCard(project)
              .contextMenu {
                Button(
                  action: { edit(project) },
                  label: { Label("EDIT_PROJECT", systemImage: "square.and.pencil") }
                )

                Button(
                  action: { show(project) },
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
      _ projects: [Project],
      edit: @escaping (Project) -> Void,
      show: @escaping (Project) -> Void
    ) {
      self.projects = projects
      self.edit = edit
      self.show = show
    }
  }
}

// MARK: - (Previews)

struct ProjectListView_Previews: PreviewProvider {
  static var previews: some View {
    Form {
      Section("1 Project") {
        HomeView.ProjectListView([.example]) { _ in } show: { _ in }
      }

      Section("3 Projects") {
        HomeView.ProjectListView([.example, .example, .example]) { _ in } show: { _ in }
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
