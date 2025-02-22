// Created by Leopold Lemmermann on 22.02.25.

import ComposableArchitecture
@testable import Projects
import Testing

@Suite(.serialized) @MainActor struct ProjectsTest {
  init() {
    prepareDependencies {
      $0.defaultDatabase = .keepinOn(inMemory: true)
    }
  }

  @Test func addProject() async throws {
    let store = TestStore(
      initialState: Projects.State(),
      reducer: Projects.init
    )
    store.exhaustivity = .off

    await store.send(.addProject)
    await store.receive(\.binding.closed)
    await store.receive(\.loadProjects)
    await store.receive(\.projects)
  }

  @Test func loadProjects() async throws {
    let store = TestStore(
      initialState: Projects.State(),
      reducer: Projects.init
    )
    store.exhaustivity = .off

    await store.send(.loadProjects)
    await store.receive(\.projects)
  }
}
