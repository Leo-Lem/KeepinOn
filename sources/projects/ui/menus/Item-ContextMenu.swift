//	Created by Leopold Lemmermann on 29.11.22.

import Errors
import LeosMisc
import SwiftUI

extension View {
  func itemContextMenu(_ item: Item) -> some View { modifier(Item.ContextMenu(item)) }
}

extension Item {
  struct ContextMenu: ViewModifier {
    let item: Item
    
    @Environment(\.size) private var size
    @Environment(\.present) private var present
    
    init(_ item: Item) { self.item = item }
    
    func body(content: Content) -> some View {
      content
#if os(iOS)
        .swipeActions(edge: .leading) { Item.ActionMenu.toggle(item) }
        .swipeActions(edge: .trailing) {
          if !item.isDone {
            Item.ActionMenu.delete(item)
            editButton()
          }
        }
#elseif os(macOS)
        .contextMenu {
          Item.ActionMenu.toggle(item)
          if !item.isDone {
            editButton()
            Item.ActionMenu.delete(item)
          }
        }
#endif
    }
    
    func editButton() -> some View {
      Button { present(MainDetail.editItem(item)) } label: { Label("EDIT", systemImage: "square.and.pencil") }
        .tint(.yellow)
        .accessibilityIdentifier("edit-item")
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct ItemContextActions_Previews: PreviewProvider {
    static var previews: some View {
      List {
        Item.RowView.Render(.example, project: .example)
          .itemContextMenu(.example)
      }
    }
  }
#endif
