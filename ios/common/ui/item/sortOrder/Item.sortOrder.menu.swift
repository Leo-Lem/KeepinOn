//	Created by Leopold Lemmermann on 10.10.22.

import SwiftUI

struct SortOrderMenu: ToolbarContent {
  @Binding var sortOrder: Item.SortOrder

  var body: some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Menu {
        ForEach(Item.SortOrder.allCases, id: \.self) { order in
          Button(order.label) {
            sortOrder = order
          }
        }
      } label: {
        Label(sortOrder.label, systemImage: "arrow.up.arrow.down")
          .labelStyle(.titleAndIcon)
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct SortOrderMenu_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      Text("Hello, world!")
        .toolbar { SortOrderMenu(sortOrder: .constant(.optimized)) }
    }
  }
}
#endif
