//	Created by Leopold Lemmermann on 10.10.22.

import SwiftUI

extension Item.SortOrder {
  func label() -> some View {
    switch self {
    case .optimized: return Label("OPTIMIZED_SORT", systemImage: "speedometer")
    case .title: return Label("CREATIONDATE_SORT", systemImage: "calendar")
    case .timestamp: return Label("TITLE_SORT", systemImage: "textformat.size.smaller")
    }
  }
  
  var title: LocalizedStringKey {
    switch self {
    case .optimized: return "OPTIMIZED_SORT"
    case .title: return "CREATIONDATE_SORT"
    case .timestamp: return "TITLE_SORT"
    }
  }
  
  mutating func next() {
    switch self {
    case .optimized: self = .title
    case .title: self = .timestamp
    case .timestamp: self = .optimized
    }
  }
}

extension Item.SortOrder {
  struct SelectionMenu: View {
    @Binding var selection: Item.SortOrder

    var body: some View {
      Menu {
        ForEach(Item.SortOrder.allCases, id: \.self) { order in
          Button(action: { selection = order }, label: order.label)
        }
      } label: {
        Label(selection.title, systemImage: "arrow.up.arrow.down")
      } primaryAction: {
        selection.next()
      }
      .labelStyle(.titleAndIcon)
      .accessibilityLabel("A11Y_ITEM_SORTORDER")
      .accessibilityValue(selection.title)
    }

    init(_ selection: Binding<Item.SortOrder>) { _selection = selection }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ItemSortOrderMenu_Previews: PreviewProvider {
  static var previews: some View {
    Binding.Preview(Item.SortOrder.optimized, content: Item.SortOrder.SelectionMenu.init)
  }
}
#endif
