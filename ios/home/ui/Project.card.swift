//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

struct ProjectCard: View {
  let projectWithItems: Project.WithItems

  var body: some View {
    VStack(alignment: .leading) {
      Text("ITEMS \(project.items.count)")
        .font(.default(.caption1))

      Text(project.label)
        .font(.default(.title2))

      ProgressView(value: progress)
        .tint(project.color)
    }
    .padding()
    .background(config.style.background)
    .cornerRadius(10)
    .shadow(color: .primary.opacity(0.2), radius: 5)
    .accessibilityElement(children: .ignore)
    .accessibilityLabel("A11Y_COMPLETE_DESCRIPTION \(project.label) \(itemsCount) \(progress)")
  }

  private var project: Project { projectWithItems.project }
  private var progress: Double { projectWithItems.progress }
  private var itemsCount: Int { projectWithItems.items.count }

  init(_ projectWithItems: Project.WithItems) { self.projectWithItems = projectWithItems }
}

// MARK: - (Previews)

struct ProjectCard_Previews: PreviewProvider {
  static var previews: some View {
    ProjectCard(.example)
      .previewDisplayName("Simple")
  }
}
