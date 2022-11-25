//	Created by Leopold Lemmermann on 30.10.22.

import Errors
import Previews
import SwiftUI

extension Project {
  func detailView() -> some View { Project.DetailView(self) }

  struct DetailView: View {
    let project: Project

    var body: some View {
      VStack {
        HStack {
          Text(project.label)
            .font(.default(.largeTitle))
            .fontWeight(.heavy)

          Image(systemName: project.isClosed ? "checkmark.diamond" : "diamond")
            .font(.default(.title1))
            .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(project.color)

        Text("\"\(project.detailsLabel)\"")
          .font(.default(.title2))
          .fontWeight(.medium)

        ProgressView(value: items.progress)
          .tint(project.color)
          .padding()

        ScrollView {
          ForEach(items, content: Item.DetailView.init)
            .padding()
        }

        Spacer()

        Text("created on \(project.timestamp.formatted())")
          .padding()
          .font(.default(.subheadline))
      }
      .accessibilityLabel("A11Y_COMPLETE_DESCRIPTION \(project.label) \(items.count) \(items.progress)")
    }

    @EnvironmentObject private var mainState: MainState

    init(_ project: Project) { self.project = project }

    private var items: [Item] {
      printError { try project.items.compactMap(mainState.localDBService.fetch) } ?? []
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct ProjectDetails_Previews: PreviewProvider {
    static var previews: some View {
      Project.DetailView(.example)
        .previewDisplayName("Bare")

      Project.example.detailView()
        .previewInSheet()
        .previewDisplayName("Sheet")
    }
  }
#endif
