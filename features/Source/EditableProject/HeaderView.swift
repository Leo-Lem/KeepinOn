// Created by Leopold Lemmermann on 20.02.25.

import ComposableArchitecture
import Data
import SwiftUIComponents

public struct ProjectHeader: View {
  public let store: StoreOf<EditableProject>

  public var body: some View{
    HStack {
      VStack(alignment: .leading) {
        HStack {
          Text(store.project.title).lineLimit(1)

          Button("SHOW_PROJECT_DETAILS", systemImage: "info.bubble") {
            // TODO: project detail
          }
          .accessibilityIdentifier("show-project-details")
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

        Button("DELETE_PROJECT", systemImage: "xmark.octagon") {
          store.send(.delete)
        }
        .tint(.red)
        // TODO: move to reducer
        //              .alert("DELETE_PROJECT_ALERT_TITLE") {
        //                Button("DELETE", role: .destructive) {
        //
        //                }
        //              } message: { Text("DELETE_PROJECT_ALERT_MESSAGE") }
        .accessibilityLabel("delete-project")
      }
    }
    .labelStyle(.iconOnly)
    .tint(store.project.color)
    .padding(.bottom, 10)
    .accessibilityElement(children: .contain)
    //          .accessibilityLabel(project.a11y)
  }

  public init(_ store: StoreOf<EditableProject>) { self.store = store }
}

#Preview {
  ProjectHeader(Store(initialState: EditableProject.State(
      project: Project(title: "Project 1", details: "These are some descriptive details.", accent: .red)
  )) {
      EditableProject()._printChanges()
    }
  )
}
