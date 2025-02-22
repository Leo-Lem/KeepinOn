// Created by Leopold Lemmermann on 22.02.25.

import ComposableArchitecture
import Data
import SwiftUIComponents

public struct ItemEditor: View {
  @Bindable public var store: StoreOf<EditableItem>

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
        Button(
          .localizable(store.item.done ? .uncomplete : .complete),
          systemImage: store.item.done ? "checkmark.circle.badge.xmark" : "checkmark.circle"
        ) {
          store.send(.toggle)
        }
        .tint(.green)
        .accessibilityIdentifier("toggle-item")
      }
    }
    .scrollDisabled(true)
    .formStyle(.grouped)
    .presentationDetents([.fraction(0.5)])
  }

  public init(_ store: StoreOf<EditableItem>) { self.store = store }
}

#Preview {
  @Previewable @State var presenting = true

  Grid {}
    .sheet(isPresented: $presenting) {
      ItemEditor(Store(initialState: EditableItem.State(.example())) { EditableItem()._printChanges() })
    }
}
