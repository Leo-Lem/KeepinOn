// Created by Leopold Lemmermann on 20.02.25.

import ComposableArchitecture
import Data
import EditableProject
import SwiftUIComponents

public struct ProjectsView: View {
  @Bindable public var store: StoreOf<Projects>

  public var body: some View {
    Section {
      List {
        ForEach(store.scope(state: \.editableProjects, action: \.projects)) { project in
          ProjectSection(project)
        }
      }
    } header: {
      HStack {
        Text("Projects")
          .font(.title)

        Button("ADD_PROJECT", systemImage: "rectangle.stack.badge.plus.fill") {
          store.send(.addProject)
        }
        .labelStyle(.iconOnly)
        .accessibilityIdentifier("add-project")

        Spacer()

        Toggle("closed", systemImage: store.closed ? "lock" : "lock.open", isOn: $store.closed)
          .toggleStyle(.button)
      }
      .padding()
    }
  }

  public init(_ store: StoreOf<Projects>) { self.store = store }
}

#Preview {
  let (_, _) = previews()

  NavigationStack {
    ProjectsView(Store(initialState: Projects.State()) { Projects()._printChanges() })
  }
}
