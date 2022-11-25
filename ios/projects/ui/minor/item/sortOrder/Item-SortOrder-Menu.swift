//	Created by Leopold Lemmermann on 10.10.22.

import SwiftUI

extension Binding where Value == Item.SortOrder {
  var selectionMenu: some ToolbarContent { Value.SelectionMenu(self) }
}

extension Item.SortOrder {
  struct SelectionMenu: ToolbarContent {
    @Binding var selection: Item.SortOrder
    
    var body: some ToolbarContent {
      ToolbarItem(placement: .navigationBarLeading) {
        Menu {
          ForEach(Item.SortOrder.allCases, id: \.self) { order in
            Button(order.label) {
              selection = order
            }
          }
        } label: {
          Label(selection.label, systemImage: "arrow.up.arrow.down")
        }
        .labelStyle(.titleAndIcon)
      }
    }
    
    init(_ selection: Binding<Item.SortOrder>) {
      _selection = selection
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct SortOrderMenu_Previews: PreviewProvider {
  static var previews: some View {
    Binding.Preview(Item.SortOrder.optimized) { binding in
      NavigationStack {
        Text("Hello, world!")
          .toolbar {
            Item.SortOrder.SelectionMenu(binding)
            binding.selectionMenu
          }
      }
    }
  }
}
#endif
