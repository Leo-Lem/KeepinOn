//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

extension Item.WithProject {
  var row: some View { Item.Row(self) }
}

extension Item {
  struct Row: View {
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
}

// MARK: - (Previews)

#if DEBUG
  struct ItemRow_Previews: PreviewProvider {
    static var previews: some View {
      Item.Row(Item.WithProject.example)
        .previewDisplayName("Simple")

      List {
        ForEach([
          Item.WithProject.example,
          Item.WithProject.example,
          Item.WithProject.example
        ], content: Item.Row.init)
      }
      .previewDisplayName("List")
    }
  }
#endif
