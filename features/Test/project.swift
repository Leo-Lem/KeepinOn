// Created by Leopold Lemmermann on 22.02.25.

import ComposableArchitecture
import Data
@testable import EditableProject
import Testing

@MainActor struct EditableProjectTest {
  let project: Project
  let store: TestStoreOf<EditableProject>

  init() {
    project = Project(id: 1, createdAt: .now, title: "Test", details: "Details", accent: .green, closed: false)

    prepareDependencies {
      $0.defaultDatabase = .keepinOn(inMemory: true)
    }

    store = TestStore(
      initialState: EditableProject.State(project),
      reducer: EditableProject.init
    )
  }

  @Test func delete() async throws {
    store.exhaustivity = .off
    await store.send(.delete)
    await store.send(.alert(.presented(.delete)))
  }

  @Test func toggle() async throws {
    await store.send(.toggle)
    await store.receive(\.binding) {
      $0.project.closed.toggle()
    }
  }

  @Test func addItem() async throws {
    await store.send(.addItem)
  }

  @Test func loadItems() async throws {
    store.exhaustivity = .off
    await store.send(.loadItems)
    await store.receive(\.items)
  }

  @Test func progress() async throws {
    @Dependency(\.defaultDatabase) var db
    try await db.write {
      var project = project
      var item = Item(projectId: project.id!, title: "Test", details: "Details", done: false)
      var item2 = Item(projectId: project.id!, title: "Test", details: "Details", done: true)
      try project.save($0)
      try item.save($0)
      try item2.save($0)
    }

    #expect(store.state.progress == 0.5)
  }

  @Test func canEdit() async throws {
    #expect(store.state.canEdit)
  }
}
