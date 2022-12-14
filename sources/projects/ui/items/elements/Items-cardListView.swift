//	Created by Leopold Lemmermann on 07.10.22.

import SwiftUI

extension Array where Element == Item {
  func cardListView(_ title: LocalizedStringKey) -> some View { ItemsCardListView(title, items: self) }
}

struct ItemsCardListView: View {
  let title: LocalizedStringKey,
      items: [Item]

  var body: some View {
    if !items.isEmpty {
      Text(title)
        .foregroundColor(.secondary)
        .padding(.top)
    }

    ForEach(items) { item in
      Button(action: { presentedItem = item }, label: item.cardView)
        .popover(
          isPresented: Binding { presentedItem == item } set: { presentedItem = $0 ? item : nil },
          content: item.detailView
        )
    }
  }

  @State private var presentedItem: Item?

  init(_ title: LocalizedStringKey, items: [Item]) {
    self.title = title
    self.items = items
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ItemsCardListView_Previews: PreviewProvider {
  static var previews: some View {
    ScrollView {
      ItemsCardListView("My Item", items: [.example])
      [Item.example, .example, .example].cardListView("My Items")
      [Item]().cardListView("No Items :(")
    }
    
  }
}
#endif
