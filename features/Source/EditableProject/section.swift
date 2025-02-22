// Created by Leopold Lemmermann on 21.02.25.

import ComposableArchitecture
import Data
import EditableItem
import SwiftUI

public struct ProjectSection: View {
  @Bindable public var store: StoreOf<EditableProject>

  public var body: some View {
    Section {
      ForEach(store.scope(state: \.editableItems, action: \.editableItems), content: ItemRow.init)

      if store.canEdit {
        Button(.localizable(.addItem), systemImage: "plus.circle") {
          store.send(.addItem)
        }
        .accessibilityIdentifier("add-item")
      }
    } header: {
      ProjectHeader(store)
    }
    .onAppear { store.send(.loadItems) }
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
