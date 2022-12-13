//	Created by Leopold Lemmermann on 07.11.22.

import SwiftUI

extension Array where Element == Project {
  func cardListView() -> some View { ProjectsCardListView(self) }
}

struct ProjectsCardListView: View {
  let projects: [Project]

  var body: some View {
    LazyHGrid(rows: [GridItem(.fixed(100))]) {
      ForEach(projects) { project in
        Button(action: { presentedProject = project }, label: project.cardView)
          .popover(
            isPresented: Binding { presentedProject == project } set: { presentedProject = $0 ? project : nil },
            content: project.detailView
          )
      }
      .padding()
    }
    .fixedSize(horizontal: false, vertical: true)
  }

  @State private var presentedProject: Project?

  init(_ projects: [Project]) { self.projects = projects }
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
    
  }
}
#endif
