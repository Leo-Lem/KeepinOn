//	Created by Leopold Lemmermann on 07.11.22.

import SwiftUI

struct ItemListView: View {
  let items: [Item],
      editingEnabled: Bool,
      add: () -> Void,
      toggleIsDone: (Item) -> Void,
      edit: (Item) -> Void,
      delete: (Item) -> Void

  @ViewBuilder var body: some View {
    ForEach(items) { item in
      SheetLink(.item(item)) { ItemRow(item) }
        .if(editingEnabled) { $0
          .addItemSwipeActions(
            item, toggleIsDone: toggleIsDone, edit: edit, delete: delete
          )
        }
    }

    if editingEnabled {
      Button(action: add, label: { Label("ADD_ITEM", systemImage: "plus") })
    }
  }
}

// MARK: - (PREVIEWS)

struct ItemListView_Previews: PreviewProvider {
  static var previews: some View {
    Form {
      ItemListView(
        items: [.example, .example, .example],
        editingEnabled: true,
        add: {},
        toggleIsDone: { _ in },
        edit: { _ in },
        delete: { _ in }
      )
    }
    .configureForPreviews()
  }
}
