//	Created by Leopold Lemmermann on 07.10.22.

import SwiftUI

extension HomeView {
  struct ItemPeekListView: View {
    let title: LocalizedStringKey,
        items: [Item],
        edit: (Item) -> Void,
        show: (Item) -> Void

    var body: some View {
      if !items.isEmpty {
        Text(title)
          .foregroundColor(.secondary)
          .padding(.top)

        ForEach(items) { item in
          ItemCard(item)
            .contextMenu {
              Button(
                action: { edit(item) },
                label: { Label("EDIT_ITEM", systemImage: "square.and.pencil") }
              )

              Button(
                action: { show(item) },
                label: { Label("SHOW_ITEM_DETAILS", systemImage: "info.bubble") }
              )
            }
        }
      }
    }

    init(
      _ title: LocalizedStringKey,
      items: [Item],
      edit: @escaping (Item) -> Void,
      show: @escaping (Item) -> Void
    ) {
      self.title = title
      self.items = items
      self.edit = edit
      self.show = show
    }
  }
}

// MARK: - (Previews)

struct ItemPeekListView_Previews: PreviewProvider {
  static var previews: some View {
    ScrollView {
      HomeView.ItemPeekListView("My Item", items: [.example]) { _ in } show: { _ in }
        .environmentObject(AppState.example)
    }
    .previewDisplayName("1 Item")

    ScrollView {
      HomeView.ItemPeekListView("My Items", items: Project.example.items) { _ in } show: { _ in }
        .environmentObject(AppState.example)
    }
    .previewDisplayName("3 Items")

    ScrollView {
      HomeView.ItemPeekListView("No Items :(", items: []) { _ in } show: { _ in }
    }
    .previewDisplayName("No Items")
  }
}
