// Created by Leopold Lemmermann on 20.02.25.

import ComposableArchitecture
import Data
import EditableItem
import EditableProject
import SwiftUIComponents

@ViewAction(for: Projects.self)
public struct ProjectsView: View {
  @Bindable public var store: StoreOf<Projects>

  public var body: some View {
    Section {
      List {
        ForEach(store.scope(state: \.filtered, action: \.projects)) { project in
          Section {
            ForEach(project.state.project.items) { item in
              ItemRow(Store(initialState: EditableItem.State(item), reducer: EditableItem.init))
            }

            if store.canEdit {
              Button("ADD_ITEM", systemImage: "plus.circle") {
                send(.addItem(to: project.state))
              }
              .accessibilityIdentifier("add-item")
            }
          } header: {
            ProjectHeader(project)
          }
        }
      }
    } header: {
      HStack {
        Text("Projects")
          .font(.title)

        Button("ADD_PROJECT", systemImage: "rectangle.stack.badge.plus.fill") {
          send(.addProject)
        }
        .labelStyle(.iconOnly)
        .accessibilityIdentifier("add-project")

        Spacer()

        Toggle("closed", systemImage: store.closed ? "lock" : "lock.open", isOn: $store.closed)
          .toggleStyle(.button)
      }
      .padding()
    }
    .onAppear { send(.appear) }
  }

  public init(_ store: StoreOf<Projects>) { self.store = store }
}

#Preview {
  let project = Project(title: "Hello", details: "some details", accent: .blue)

  NavigationStack {
    ProjectsView(Store(initialState: Projects.State(projects: [
      project,
      Project(title: "Goodbye", details: "some other details which are longer", accent: .red),
      Project(title: "Goodbye", details: "some other details which are longer", accent: .green, closed: true)
    ])) { Projects()._printChanges() })
  }
  .onAppear {
    SwiftDatabase.start()
    project.items = [
      Item(title: "Item 1", details: "details here"),
      Item(title: "Item 2", details: "details here")
    ]
  }
}
