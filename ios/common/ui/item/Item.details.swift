//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

struct ItemDetails: View {
  let item: Item

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
      .foregroundColor(item.color)

      Text("\"\(item.detailsLabel)\"")
        .font(.default(.title2))
        .fontWeight(.medium)

      if let project = item.project {
        ProjectCard(project)
      }

      Spacer()

      Text("created on \(item.timestamp.formatted())")
        .padding()
        .font(.default(.subheadline))
    }
    .preferred(style: SheetViewStyle(size: .half, dismissButtonStyle: .hidden))
  }

  init(_ item: Item) {
    self.item = item
  }
}

// MARK: - (Previews)

struct ItemDetails_Previews: PreviewProvider {
  static var previews: some View {
    ItemDetails(.example)
      .previewDisplayName("Bare")

    SheetView.Preview {
      ItemDetails(.example)
    }
    .previewDisplayName("Sheet")
  }
}
