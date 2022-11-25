//	Created by Leopold Lemmermann on 07.11.22.

import SwiftUI

extension Array where Element == Project {
  func cardListView() -> some View { ProjectsCardListView(self) }
}

  struct ProjectsCardListView: View {
    let projects: [Project]
    
    var body: some View {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHGrid(rows: [GridItem(.fixed(100))]) {
          ForEach(projects) { project in
            Menu {
              Button { startEditing(project) } label: {
                Label("EDIT_PROJECT", systemImage: "square.and.pencil")
              }
              
              Button { showInfo(for: project) } label: {
                Label("SHOW_PROJECT_DETAILS", systemImage: "info.bubble")
              }
            } label: {
              project.cardView()
            }
          }
          .padding()
        }
        .fixedSize(horizontal: false, vertical: true)
      }
    }
    
    @EnvironmentObject private var mainState: MainState
    
    init(_ projects: [Project]) { self.projects = projects }
  }

extension ProjectsCardListView {
  func startEditing(_ project: Project) {
    mainState.didChange.send(.sheet(.editProject(project)))
  }

  func showInfo(for project: Project) {
    mainState.didChange.send(.sheet(.project(project)))
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
      Form {
        Section("1 Project") {
          ProjectsCardListView([.example])
        }

        Section("3 Projects") {
          [Project.example, .example, .example].cardListView()
        }

        Section("No Projects") {
          [Project]().cardListView()
        }
      }
      .formStyle(.columns)
      .padding()
      .configureForPreviews()
    }
  }
#endif
