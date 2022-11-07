//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

struct ItemRow: View {
  let item: Item

  var body: some View {
    Label(title: Text(item.label).fixedSize) {
      Image(systemName: item.icon)
        .foregroundColor(item.color)
        .accessibilityLabel(item.a11y)
    }
  }

  init(_ item: Item) {
    self.item = item
  }
}

// MARK: - (Previews)

struct ItemRow_Previews: PreviewProvider {
  static var previews: some View {
    ItemRow(.example)
      .previewDisplayName("Simple")

    List {
      ForEach([Item.example, .example, .example], content: ItemRow.init)
    }
    .previewDisplayName("List")
  }
}
