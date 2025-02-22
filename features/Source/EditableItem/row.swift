// Created by Leopold Lemmermann on 20.02.25.

import ComposableArchitecture
import Data
import SwiftUIComponents

public struct ItemRow: View {
  @Bindable public var store: StoreOf<EditableItem>

  public var body: some View {
    Button {
      // TODO: item detail
    } label: {
      HStack {
        Image(systemName: store.item.icon)
          .foregroundColor(store.project?.color)

        Text(store.item.title)

        Text(store.item.details)
          .lineLimit(1)
          .foregroundColor(.secondary)
      }
    }
    .disabled(true)
    .accessibilityValue(store.item.title)
    .accessibilityLabel("A11Y_ITEM")
    .swipeActions(edge: .leading) {
      if store.canEdit {
        Button(
          store.item.done ? "UNCOMPLETE_ITEM" : "COMPLETE_ITEM",
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
        Button("DELETE", systemImage: "trash") {
          store.send(.delete)
        }
        .tint(.red)
        .accessibilityIdentifier("delete-item")

        Button("EDIT", systemImage: "square.and.pencil") {
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
