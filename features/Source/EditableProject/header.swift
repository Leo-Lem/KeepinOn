// Created by Leopold Lemmermann on 20.02.25.

import ComposableArchitecture
import Data
import SwiftUIComponents

public struct ProjectHeader: View {
  @Bindable public var store: StoreOf<EditableProject>

  public var body: some View{
    HStack {
      VStack(alignment: .leading) {
        HStack {
          Text(store.project.title).lineLimit(1)

          Button(.localizable(.details), systemImage: "info.bubble") {
            store.detail = true
          }
          .accessibilityIdentifier("show-project-details")
          .sheet(isPresented: $store.detail) {
            ProjectDetail(store.withItems)
          }
        }

        ProgressView(value: store.progress)
          .progressViewStyle(.linear)
      }

      Spacer()

      Button(
        .localizable(store.project.closed ? .reopen : .close),
        systemImage: store.project.closed ? "lock.open" : "lock"
      ) {
        store.send(.toggle)
      }
      .accessibilityIdentifier("toggle-project")

      if !store.project.closed {
        Button(.localizable(.edit), systemImage: "square.and.pencil") {
          store.editing = true
        }
        .tint(.yellow)
        .accessibilityIdentifier("edit-project")
        .sheet(isPresented: $store.editing) {
          ProjectEditor(store)
        }

        Button(.localizable(.delete), systemImage: "xmark.octagon") {
          store.send(.delete)
        }
        .tint(.red)
        .accessibilityIdentifier("delete-project")
        .alert($store.scope(state: \.alert, action: \.alert))
      }
    }
    .labelStyle(.iconOnly)
    .tint(store.project.accent.color)
    .padding(.bottom, 10)
    .accessibilityElement(children: .contain)
    .accessibilityLabel(store.project.a11y)
  }

  public init(_ store: StoreOf<EditableProject>) { self.store = store }
}

#Preview {
  Section {
    Text("Nothing to see here…")
  } header: {
    ProjectHeader(
      Store(initialState: EditableProject.State(previews().projects[0])) { EditableProject()._printChanges() }
    )
  }
  .padding()
}
