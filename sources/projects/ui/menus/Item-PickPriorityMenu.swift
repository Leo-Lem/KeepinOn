// Created by Leopold Lemmermann on 20.12.22.

import LeosMisc
import SwiftUI

extension Item {
  struct PickPriorityMenu: View {
    let id: Item.ID
      
    var body: some View {
      WithEditableConvertibleViewStore(
        with: id, from: \.privateDatabase.items, loadWith: .init { .privateDatabase(.items($0)) }
      ) { editable in
        Unwrap(editable.convertible) { (item: Item) in
          Item.Priority.SelectionMenu(priority: .init { item.priority } set: { editable.send(.modify(\.priority, $0)) })
        }
      }
    }
  }
}
