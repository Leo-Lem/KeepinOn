// Created by Leopold Lemmermann on 20.02.25.

import ComposableArchitecture
import Data
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
//            items(project)
          } header: {
            ProjectHeader(project)
          }
        }
      }
    } header: {
      HStack {
        Text("Projects")
          .font(.largeTitle)
        Spacer()
        Toggle("closed", systemImage: store.closed ? "lock" : "lock.open", isOn: $store.closed)
          .toggleStyle(.button)
      }
      .padding()
    }
    .onAppear { send(.appear) }
  }

  func items(_ project: Project) -> some View {
    ForEach(project.items) { item in
      HStack {
        Image(systemName: item.icon)
          .foregroundColor(project.color)

        Text(item.title)

        Text(item.details)
          .lineLimit(1)
          .foregroundColor(.secondary)
      }
      .accessibilityValue(item.title)
      //            .accessibilityLabel(item.a11y)
      .swipeActions(edge: .leading) {
        if store.canEdit {
          Button(
            item.done ? "UNCOMPLETE_ITEM" : "COMPLETE_ITEM",
            systemImage: item.done ? "checkmark.circle.badge.xmark" : "checkmark.circle"
          ) {
            item.done.toggle()
          }
          .tint(.green)
          .accessibilityIdentifier("toggle-item")
        }
      }
      .swipeActions(edge: .trailing) {
        if store.canEdit && !item.done {
          Button("DELETE", systemImage: "trash") {
//            send(.deleteItem(item))
          }
          .tint(.red)
          .accessibilityIdentifier("delete-item")

          Button("EDIT", systemImage: "square.and.pencil") {
            // TODO: edit item
          }
          .tint(.yellow)
          .accessibilityIdentifier("edit-item")
        }
      }
      .onTapGesture {
        // TODO: item detail
      }

      if store.canEdit {
        //              AsyncButton(indicatorStyle: .edge(.trailing), taskPriority: .userInitiated) {
        //                guard !limitIsReached else { return }
        //                await add()
        //              } label: {
        //                Label("ADD_ITEM", systemImage: "plus.circle")
        //              }
        //              .accessibilityIdentifier("add-item")
      }
    }
  }

  public init(_ store: StoreOf<Projects>) { self.store = store }
}

#Preview {
  let project = Project(title: "Hello", details: "some details", accent: .blue)

  ProjectsView(Store(initialState: Projects.State(projects: [
    project,
    Project(title: "Goodbye", details: "some other details which are longer", accent: .red),
    Project(title: "Goodbye", details: "some other details which are longer", accent: .green, closed: true)
  ])) { Projects()._printChanges() })
  .onAppear {
    SwiftDatabase.start()
    project.items = [
      Item(title: "Item 1", details: "details here"),
      Item(title: "Item 2", details: "details here")
    ]
  }
}
