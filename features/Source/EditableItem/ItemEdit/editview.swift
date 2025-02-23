// Created by Leopold Lemmermann on 22.02.25.

import ComposableArchitecture
import Data
import SwiftUIComponents

public struct ItemEditView: View {
  @Bindable public var store: StoreOf<ItemEdit>

  public var body: some View {
    Form {
      Section {
        TextField(.localizable(.titlePlaceholder), text: $store.item.title)
          .accessibilityLabel(.localizable(.a11yEditTitle))
          .accessibilityIdentifier("edit-item-name")

        TextField(.localizable(.detailsPlaceholder), text: $store.item.details)
          .accessibilityLabel(.localizable(.a11yEditDetails))
          .accessibilityIdentifier("edit-item-description")
      }
      Section(.localizable(.priority)) {
        PriorityPicker($store.item.priority)
      }

      Section {
        ItemToggle($store.item.done)
      }
    }
    .scrollDisabled(true)
    .formStyle(.grouped)
    .presentationDetents([.fraction(0.5)])
  }

  public init(_ store: StoreOf<ItemEdit>) { self.store = store }
}

#Preview {
  @Previewable @State var presenting = true

  Grid {}
    .sheet(isPresented: $presenting) {
      ItemEditView(Store(initialState: ItemEdit.State(previews().items[0])) { ItemEdit()._printChanges() })
    }
}
