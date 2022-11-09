//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

struct ItemDetails: View {
  let item: Item,
      projectWithItems: Project.WithItems

  var body: some View {
    VStack {
      HStack {
        PriorityView(item.priority)
          .font(.default(.headline))
          .bold()
        Text(item.label)
          .font(.default(.largeTitle))
          .fontWeight(.heavy)
        Image(systemName: item.isDone ? "checkmark.circle" : "circle")
          .font(.default(.title1))
          .fontWeight(.bold)
      }
      .padding()
      .frame(maxWidth: .infinity)
      .foregroundColor(project.color)

      Text("\"\(item.detailsLabel)\"")
        .font(.default(.title2))
        .fontWeight(.medium)

      ProjectCard(projectWithItems)

      Spacer()

      Text("created on \(item.timestamp.formatted())")
        .padding()
        .font(.default(.subheadline))
    }
    .preferred(style: SheetViewStyle(size: .half, dismissButtonStyle: .hidden))
  }

  private var project: Project { projectWithItems.project }
  
  init(
    _ item: Item,
    projectWithItems: Project.WithItems
  ) {
    self.item = item
    self.projectWithItems = projectWithItems
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ItemDetails_Previews: PreviewProvider {
  static var previews: some View {
    ItemDetails(.example, projectWithItems: .example)
      .previewDisplayName("Bare")

    SheetView.Preview {
      ItemDetails(.example, projectWithItems: .example)
    }
    .previewDisplayName("Sheet")
  }
}
#endif
