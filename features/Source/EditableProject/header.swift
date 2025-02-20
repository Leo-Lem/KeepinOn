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

          Button("SHOW_PROJECT_DETAILS", systemImage: "info.bubble") {
            // TODO: project detail
          }
          .accessibilityIdentifier("show-project-details")
          .disabled(true)
        }

        ProgressView(value: store.project.progress)
          .progressViewStyle(.linear)
      }

      Spacer()

      Button(
        store.project.closed ? "REOPEN_PROJECT" : "CLOSE_PROJECT",
        systemImage: store.project.closed ? "lock.open" : "lock"
      ) {
        store.send(.toggle)
      }
      .accessibilityLabel("toggle-project")

      if !store.project.closed {
        Button("EDIT_PROJECT", systemImage: "square.and.pencil") {
          // TODO: edit project
        }
        .tint(.yellow)
        .accessibilityIdentifier("edit-project")
        .disabled(true)

        Button("DELETE_PROJECT", systemImage: "xmark.octagon") {
          store.send(.delete)
        }
        .tint(.red)
        .alert($store.scope(state: \.alert, action: \.alert))
        .accessibilityLabel("delete-project")
      }
    }
    .labelStyle(.iconOnly)
    .tint(store.project.color)
    .padding(.bottom, 10)
    .accessibilityElement(children: .contain)
    .accessibilityLabel("A11Y_PROJECT")
  }

  public init(_ store: StoreOf<EditableProject>) { self.store = store }
}

#Preview {
  let project = Project(title: "Project 1", details: "These are some descriptive details.", accent: .red)
  Section {
    Text("Nothing to see here…")
  } header: {
    ProjectHeader(Store(initialState: EditableProject.State(project)) { EditableProject()._printChanges() })
  }
  .padding()
  .onAppear { SwiftDatabase.start() }
}
