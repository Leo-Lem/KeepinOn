// Created by Leopold Lemmermann on 22.02.25.

import ComposableArchitecture
import Data
import SwiftUIComponents

public struct ProjectEditor: View {
  @Bindable public var store: StoreOf<EditableProject>

  public var body: some View {
    Form {
      Section {
        TextField(.localizable(.titlePlaceholder), text: $store.project.title)
          .accessibilityLabel(.localizable(.a11yEditTitle))
          .accessibilityIdentifier("edit-project-name")

        TextField(.localizable(.detailsPlaceholder), text: $store.project.details)
          .accessibilityLabel(.localizable(.a11yEditDetails))
          .accessibilityIdentifier("edit-project-description")
      }

      Section(.localizable(.pickColor)) {
        AccentPicker($store.project.accent)
      }

      Section {
        Button(
          .localizable(store.project.closed ? .reopen : .close),
          systemImage: store.project.closed ? "lock.open" : "lock"
        ) {
          store.send(.toggle)
          store.editing = false
        }
        .accessibilityIdentifier("toggle-project")

        Button(.localizable(.delete), systemImage: "xmark.octagon") {
          store.send(.delete)
        }
        .tint(.red)
        .alert($store.scope(state: \.alert, action: \.alert))
        .accessibilityIdentifier("delete-project")
      } footer: {
        Text(localizable: .deleteWarning)
      }
    }
    .formStyle(.grouped)
    .navigationTitle(.localizable(.editProject))
    .animation(.default, value: store.project)
  }

  public init(_ store: StoreOf<EditableProject>) { self.store = store }
}

#Preview {
  ProjectEditor(Store(initialState: EditableProject.State(previews().projects[0])) {
    EditableProject()._printChanges()
  })
}
