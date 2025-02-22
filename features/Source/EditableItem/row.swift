// Created by Leopold Lemmermann on 20.02.25.

import ComposableArchitecture
import Data
import SwiftUIComponents

public struct ItemRow: View {
  @Bindable public var store: StoreOf<EditableItem>

  public var body: some View {
    Button {
      store.send(.detail)
    } label: {
      HStack {
        Image(systemName: store.item.icon)
          .foregroundColor(store.accent?.color)

        Text(store.item.title)

        Text(store.item.details)
          .lineLimit(1)
          .foregroundColor(.secondary)
      }
    }
    .accessibilityValue(store.item.title)
    .accessibilityLabel(store.item.a11y)
    .swipeActions(edge: .leading) {
      if store.canEdit {
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
    .swipeActions(edge: .trailing) {
      if store.canEdit && !store.item.done {
        Button(.localizable(.delete), systemImage: "trash") {
          store.send(.delete)
        }
        .tint(.red)
        .accessibilityIdentifier("delete-item")

        Button(.localizable(.edit), systemImage: "square.and.pencil") {
          // TODO: edit item
        }
        .tint(.yellow)
        .accessibilityIdentifier("edit-item")
        .disabled(true)
      }
    }
  }

  public init(_ store: StoreOf<EditableItem>) { self.store = store }
}

#Preview {
  List {
    ItemRow(Store(initialState: EditableItem.State(previews().items[0])) { EditableItem()._printChanges() })
  }
}
