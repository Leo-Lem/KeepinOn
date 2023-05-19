// Created by Leopold Lemmermann on 20.12.22.

import LeosMisc
import SwiftUI

extension Item {
  struct EditDescriptionMenu: View {
    let id: Item.ID
      
    var body: some View {
      WithEditableConvertibleViewStore(
        with: id, from: \.privateDatabase.items, loadWith: .init { .privateDatabase(.items($0)) }
      ) { editable in
        Unwrap(editable.convertible) { (item: Item) in
          Render(
            item: item,
            newTitle: Binding { item.title } set: { editable.send(.modify(\.title, $0)) },
            newDetails: Binding { item.details } set: { editable.send(.modify(\.details, $0)) }
          )
        }
      }
    }
      
    struct Render: View {
      let item: Item
      @Binding var newTitle: String
      @Binding var newDetails: String
      
      var body: some View {
        TextField(item.title ??? String(localized: "ITEM_NAME_PLACEHOLDER"), text: $newTitle)
          .accessibilityIdentifier("edit-item-name")
          .onChange(of: item.title) { if newTitle != $0 { newTitle = "" } }
        
        TextField(item.details ??? String(localized: "ITEM_DESCRIPTION_PLACEHOLDER"), text: $newDetails)
          .accessibilityIdentifier("edit-item-description")
          .onChange(of: item.details) { if newDetails != $0 { newDetails = "" } }
      }
    }
  }
}
