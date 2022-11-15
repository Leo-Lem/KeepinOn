//	Created by Leopold Lemmermann on 07.10.22.

import SwiftUI

extension HomeView {
  struct ItemPeekListView: View {
    let title: LocalizedStringKey,
        itemsWithProject: [Item.WithProject],
        edit: (Item) -> Void,
        show: (Item.WithProject) -> Void

    var body: some View {
      if !itemsWithProject.isEmpty {
        Text(title)
          .foregroundColor(.secondary)
          .padding(.top)

        ForEach(itemsWithProject) { itemWithProject in
          Item.Card(itemWithProject)
            .contextMenu {
              Button(
                action: { edit(itemWithProject.item) },
                label: { Label("EDIT_ITEM", systemImage: "square.and.pencil") }
              )

              Button(
                action: { show(itemWithProject) },
                label: { Label("SHOW_ITEM_DETAILS", systemImage: "info.bubble") }
              )
            }
        }
      }
    }

    init(
      _ title: LocalizedStringKey,
      itemsWithProject: [Item.WithProject],
      edit: @escaping (Item) -> Void,
      show: @escaping (Item.WithProject) -> Void
    ) {
      self.title = title
      self.itemsWithProject = itemsWithProject
      self.edit = edit
      self.show = show
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct ItemPeekListView_Previews: PreviewProvider {
    static var previews: some View {
      ScrollView {
        HomeView.ItemPeekListView(
          "My Item",
          itemsWithProject: [Item.WithProject.example]
        ) { _ in } show: { _ in }
        HomeView.ItemPeekListView(
          "My Items",
          itemsWithProject: [
            Item.WithProject.example,
            Item.WithProject.example,
            Item.WithProject.example
          ]
        ) { _ in } show: { _ in }
        HomeView.ItemPeekListView(
          "No Items :(",
          itemsWithProject: []
        ) { _ in } show: { _ in }
      }
      .configureForPreviews()
    }
  }
#endif
