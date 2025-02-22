// Created by Leopold Lemmermann on 22.02.25.

import ComposableArchitecture
import Data
@testable import EditableItem
import Testing

@MainActor struct EditableItemTest {
  let item: Item
  let store: TestStoreOf<EditableItem>

  init() {
    item = Item(id: 1, createdAt: .now, projectId: 1, title: "Test", details: "Details")

    prepareDependencies {
      $0.defaultDatabase = .keepinOn(inMemory: true)
    }

    store = TestStore(
      initialState: EditableItem.State(item),
      reducer: EditableItem.init
    )
  }

  @Test func delete() async throws {
    await store.send(.delete)
  }

  @Test func toggle() async throws {
    await store.send(.toggle)

    await store.receive(\.binding) {
      $0.item.done.toggle()
    }

    await store.send(.toggle)

    await store.receive(\.binding) {
      $0.item.done.toggle()
    }
  }

  @Test func project() async throws {
    let project = Project(id: item.projectId, title: "Title", details: "Details", accent: .green)

    @Dependency(\.defaultDatabase) var db
    try await db.write {
      var project = project
      var item = item
      try project.save($0)
      try item.save($0)
    }

    #expect(store.state.accent == project.accent)
  }

  @Test func canEdit() async throws {
    let project = Project(id: item.projectId, title: "Title", details: "Details", accent: .green, closed: true)

    @Dependency(\.defaultDatabase) var db
    try await db.write {
      var project = project
      var item = item
      try project.save($0)
      try item.save($0)
    }

    #expect(!store.state.canEdit)
  }
}
