// Created by Leopold Lemmermann on 22.02.25.

import ComposableArchitecture
@testable import Featured
import Testing

@MainActor struct FeaturedTest {
  init() {
    prepareDependencies {
      $0.defaultDatabase = .keepinOn(inMemory: true)
    }
  }

  @Test func empty() async throws {
    let store = TestStore(
      initialState: Featured.State(),
      reducer: Featured.init
    )

    #expect(store.state.projects.isEmpty)
    #expect(store.state.items.isEmpty)
  }
}
