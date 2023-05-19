// Created by Leopold Lemmermann on 16.12.22.

import SwiftUI

extension Project {
  struct FeaturedView: View {
    var body: some View {
      WithConvertiblesViewStore(
        matching: .init(\.isClosed, false),
        from: \.privateDatabase.projects,
        loadWith: .init { MainReducer.Action.privateDatabase(.projects($0)) }
      ) { projects in
        Render(projects.sorted(by: \.timestamp))
      }
    }

    struct Render: View {
      let projects: [Project]

      var body: some View {
        Group {
          if size == .compact {
            ScrollView(.horizontal, showsIndicators: false) {
              LazyHGrid(rows: [GridItem()], content: list)
                .padding(.horizontal)
            }
            .border(.leading, .trailing)
            .frame(height: 100)
            .padding()
          } else {
            ScrollView {
              VStack(content: list)
                .padding()
            }
          }
        }
        .replace(if: projects.isEmpty) {
          Project.AddMenu()
            .buttonStyle(.presentBordered())
            .padding()
            .accessibilityIdentifier("add-first-project")
        }
        .accessibilityIdentifier("featured-projects-list")
      }

      @SwiftUI.State private var presentedProject: Project?
      @Environment(\.size) private var size

      init(_ projects: [Project]) { self.projects = projects }

      private func list() -> some View {
        ForEach(projects) { project in
          project.peekView()
            .onTapGesture { presentedProject = project }
            .presentModal($presentedProject, presented: project) { Project.DetailView(id: $0.id) }
        }
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ProjectFeaturedView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Project.FeaturedView.Render([]).previewDisplayName("Empty")
      Project.FeaturedView.Render([.example, .example, .example])
    }
    .presentPreview()
  }
}
#endif
