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
          .foregroundColor(store.item.project?.color)

        Text(store.item.title)

        Text(store.item.details)
          .lineLimit(1)
          .foregroundColor(.secondary)
      }
    }
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
        .disabled(true)

        Button("EDIT", systemImage: "square.and.pencil") {
          // TODO: edit item
        }
        .tint(.yellow)
        .accessibilityIdentifier("edit-item")
        .disabled(true)
      }
    }
    .disabled(true)
  }

  public init(_ store: StoreOf<EditableItem>) { self.store = store }
}

#Preview {
  let project = Project(title: "Project 1", details: "", accent: .red, closed: false)
  let item = Item(title: "Item 1", details: "Some details about this item.", project: project)

  List {
    ItemRow(Store(initialState: EditableItem.State(item)) { EditableItem()._printChanges() })
  }
  .onAppear { SwiftDatabase.start() }
}
