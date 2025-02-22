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
            // TODO: project detail
          }
          .accessibilityIdentifier("show-project-details")
          .disabled(true)
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
          // TODO: edit project
        }
        .tint(.yellow)
        .accessibilityIdentifier("edit-project")
        .disabled(true)

        Button(.localizable(.delete), systemImage: "xmark.octagon") {
          store.send(.delete)
        }
        .tint(.red)
        .accessibilityIdentifier("delete-project")
      }
    }
    .labelStyle(.iconOnly)
    .tint(store.project.color)
    .padding(.bottom, 10)
    .accessibilityElement(children: .contain)
    .accessibilityLabel(.localizable(.a11yProject(store.progress.formatted(.percent))))
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
