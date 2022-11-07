//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

struct ProjectCard: View {
  let project: Project

  var body: some View {
    VStack(alignment: .leading) {
      Text("ITEMS \(project.items.count)")
        .font(.default(.caption1))

      Text(project.label)
        .font(.default(.title2))

      ProgressView(value: project.progress)
        .tint(project.color)
    }
    .padding()
    .background(Color(.secondarySystemGroupedBackground))
    .cornerRadius(10)
    .shadow(color: .primary.opacity(0.2), radius: 5)
    .accessibilityElement(children: .ignore)
    .accessibilityLabel(project.a11y)
  }

  init(_ project: Project) {
    self.project = project
  }
}

// MARK: - (Previews)

struct ProjectCard_Previews: PreviewProvider {
  static var previews: some View {
    ProjectCard(.example)
      .previewDisplayName("Simple")
  }
}
