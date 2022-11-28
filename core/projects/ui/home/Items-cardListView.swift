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

      ForEach(items) { item in
        Menu {
          Button { startEditing(item) } label: {
            Label("EDIT_ITEM", systemImage: "square.and.pencil")
          }

          Button { showInfo(for: item) } label: {
            Label("SHOW_ITEM_DETAILS", systemImage: "info.bubble")
          }
        } label: {
          item.cardView()
        }
      }
    }
  }

  @EnvironmentObject private var mainState: MainState

  init(_ title: LocalizedStringKey, items: [Item]) {
    self.title = title
    self.items = items
  }
}

private extension ItemsCardListView {
  func startEditing(_ item: Item) {
    mainState.didChange.send(.sheet(.editItem(item)))
  }

  func showInfo(for item: Item) {
    mainState.didChange.send(.sheet(.item(item)))
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
