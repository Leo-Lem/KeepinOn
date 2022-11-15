//	Created by Leopold Lemmermann on 07.11.22.

import SwiftUI

extension View {
  func addItemSwipeActions(
    _ item: Item,
    toggleIsDone: @escaping (Item) -> Void,
    edit: @escaping (Item) -> Void,
    delete: @escaping (Item) -> Void
  ) -> some View {
    let toggleIsDone = { toggleIsDone(item) },
        edit = { edit(item) },
        delete = { delete(item) }

    return swipeActions(edge: .leading) {
      Button(
        action: toggleIsDone,
        label: {
          item.isDone ?
            Label("UNCOMPLETE_ITEM", systemImage: "checkmark.circle.badge.xmark") :
            Label("COMPLETE_ITEM", systemImage: "checkmark.circle")
        }
      )
      .tint(.green)
    }
    .swipeActions(edge: .trailing) {
      Button(
        action: delete,
        label: { Label("GENERIC_DELETE", systemImage: "trash") }
      )
      .tint(.red)

      Button(
        action: edit,
        label: { Label("GENERIC_EDIT", systemImage: "square.and.pencil") }
      )
      .tint(.yellow)
    }
  }
}
