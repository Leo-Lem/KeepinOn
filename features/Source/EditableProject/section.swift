// Created by Leopold Lemmermann on 21.02.25.

import ComposableArchitecture
import Data
import EditableItem
import SwiftUI

public struct ProjectSection: View {
  @Bindable public var store: StoreOf<EditableProject>

  public var body: some View {
    Section {
      ForEach(store.scope(state: \.editableItems, action: \.items)) { item in
        ItemRow(item)
      }

      if store.canEdit {
        Button("ADD_ITEM", systemImage: "plus.circle") {
          store.send(.addItem)
        }
        .accessibilityIdentifier("add-item")
      }
    } header: {
      ProjectHeader(store)
    }
    .alert($store.scope(state: \.alert, action: \.alert))
  }

  public init(_ store: StoreOf<EditableProject>) { _store = Bindable(store) }
}

#Preview {
  List {
    ProjectSection(
      Store(initialState: EditableProject.State(previews().projects[0])) { EditableProject()._printChanges() }
    )
  }
}
