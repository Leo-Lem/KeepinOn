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
    
    init(_ item: Item) { self.item = item }
    
    func body(content: Content) -> some View {
      WithPresentationViewStore { _, detail in
        content
#if os(iOS)
          .swipeActions(edge: .leading) { Item.ToggleMenu(id: item.id) }
          .swipeActions(edge: .trailing) {
            if !item.isDone {
              Item.DeleteMenu(id: item.id)
              editButton { detail.wrappedValue = .editItem(id: item.id) }
            }
          }
#elseif os(macOS)
          .contextMenu {
            Item.ToggleMenu(id: item.id)
            if !item.isDone {
              editButton { detail.wrappedValue = .editItem(id: item.id) }
              Item.DeleteMenu(id: item.id)
            }
          }
#endif
      }
    }
    
    func editButton(_ present: @escaping () -> Void) -> some View {
      Button(action: present) { Label("EDIT", systemImage: "square.and.pencil") }
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
