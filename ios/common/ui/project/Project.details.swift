//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

struct ProjectDetails: View {
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

      ProgressView(value: project.progress)
        .tint(project.color)
        .padding()

      ScrollView {
        ForEach(project.items, content: ItemCard.init)
          .padding()
      }

      Spacer()

      Text("created on \(project.timestamp.formatted())")
        .padding()
        .font(.default(.subheadline))
    }
    .accessibilityLabel(project.a11y)
    .preferred(style: SheetViewStyle(dismissButtonStyle: .hidden))
  }

  init(_ project: Project) {
    self.project = project
  }
}

// MARK: - (Previews)

struct ProjectDetails_Previews: PreviewProvider {
  static var previews: some View {
    ProjectDetails(.example)
      .previewDisplayName("Bare")

    SheetView.Preview {
      ProjectDetails(.example)
    }
    .previewDisplayName("Sheet")
  }
}
