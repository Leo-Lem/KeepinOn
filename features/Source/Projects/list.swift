// Created by Leopold Lemmermann on 20.02.25.

import ComposableArchitecture
import Data
import EditableProject
import SwiftUIComponents

public struct ProjectsList: View {
  @Bindable public var store: StoreOf<Projects>

  public var body: some View {
    Section {
      List {
        ForEach(store.scope(state: \.editableProjects, action: \.editableProjects)) { project in
          ProjectSection(project)
        }
      }
    } header: {
      HStack {
        Text(localizable: .title)
          .font(.title)

        Button(.localizable(.addProject), systemImage: "rectangle.stack.badge.plus.fill") {
          store.send(.addProject)
        }
        .labelStyle(.iconOnly)
        .accessibilityIdentifier("add-project")

        Spacer()

        Toggle(.localizable(.closed), systemImage: store.closed ? "lock" : "lock.open", isOn: $store.closed)
          .toggleStyle(.button)
      }
      .padding()
      .onAppear { store.send(.loadProjects) }
      .animation(.default, value: store.projects)
    }
  }

  public init(_ store: StoreOf<Projects>) { self.store = store }
}

#Preview {
  NavigationStack {
    ProjectsList(Store(initialState: Projects.State(projects: previews().projects)) { Projects()._printChanges() })
  }
}
