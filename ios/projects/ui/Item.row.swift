//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

struct ItemRow: View {
  let itemWithProject: Item.WithProject

  var body: some View {
    Label(title: Text(item.label).fixedSize) {
      Image(systemName: item.icon)
        .foregroundColor(itemWithProject.project.color)
        .accessibilityLabel(item.a11y)
    }
  }
  
  private var item: Item { itemWithProject.item }
  
  init(_ itemWithProject: Item.WithProject) { self.itemWithProject = itemWithProject }
}

// MARK: - (Previews)

#if DEBUG
struct ItemRow_Previews: PreviewProvider {
  static var previews: some View {
    ItemRow(.example)
      .previewDisplayName("Simple")

    List {
      ForEach([Item.WithProject.example, .example, .example], content: ItemRow.init)
    }
    .previewDisplayName("List")
  }
}
#endif
