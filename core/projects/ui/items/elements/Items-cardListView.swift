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
      item.cardView()
        .platformAdjustedMenu { presentedItem = item } actions: {
          #if os(iOS)
          Button { mainState.showPresentation(detail: .editItem(item)) } label: {
            Label("EDIT_ITEM", systemImage: "square.and.pencil")
          }
          #endif
        }
        .popover(
          isPresented: Binding { presentedItem == item } set: { presentedItem = $0 ? item : nil },
          content: item.detailView
        )
    }
  }

  @State private var presentedItem: Item?
  @EnvironmentObject private var mainState: MainState

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
    .configureForPreviews()
  }
}
#endif
