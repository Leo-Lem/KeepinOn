// Created by Leopold Lemmermann on 20.02.25.

import ComposableArchitecture
import Data
import SwiftUIComponents

public struct ItemRow: View {
  @Bindable public var store: StoreOf<EditableItem>

  public var body: some View {
    Button {
      store.send(.detailTapped)
    } label: {
      HStack {
        Toggle(.localizable(.edit), systemImage: store.item.icon, isOn: $store.item.sending(\.item).done)
          .toggleStyle(.button)
          .labelStyle(.iconOnly)
          .tint(store.accent.color.opacity(0.7))
          .foregroundColor(store.accent.color)
          .disabled(!store.canEdit)

        Text(store.item.title)

        Text(store.item.details)
          .lineLimit(1)
          .foregroundColor(.secondary)

        Button(.localizable(.edit), systemImage: "square.and.pencil") {
          store.editing = true
        }
        .labelStyle(.iconOnly)
        .accessibilityIdentifier("edit-item")
      }
    }
    .accessibilityValue(store.item.title)
    .accessibilityLabel(store.item.a11y)
    .swipeActions(edge: .leading) {
      if store.canEdit && !store.item.done {
        Button(.localizable(.delete), systemImage: "trash") {
          store.send(.delete)
        }
        .tint(.red)
        .accessibilityIdentifier("delete-item")
      }
    }
    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
      if store.canEdit {
        Button(.localizable(.delete), systemImage: "trash") {
          store.send(.deleteTapped)
        }
        .tint(.red)
        .accessibilityIdentifier("delete-item")
      }
    }
    .sheet(item: $store.scope(state: \.detail, action: \.detail)) {
      ItemDetailView($0)
    }
    .sheet(item: $store.scope(state: \.edit, action: \.edit)) {
      ItemEditView($0)
    }
  }

  public init(_ store: StoreOf<EditableItem>) { self.store = store }
}

#Preview {
  List {
    ForEach(previews().items, id: \.id) { item in
      ItemRow(Store(initialState: EditableItem.State(item.id)) { EditableItem()._printChanges() })
    }
  }
}
