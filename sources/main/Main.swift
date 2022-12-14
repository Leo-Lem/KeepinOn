//  Created by Leopold Lemmermann on 24.10.22.

import CloudKitService
import ComposableArchitecture
import Concurrency
import SwiftUI

// TODO: add widget updates
// TODO: fix the async button progress view being too large on macos
// TODO: reimplement the banner
// TODO: move navigation into reducer
// TODO: add errors to reducer

@main struct Main: App {
  var body: some Scene {
    WindowGroup {
      if isReady {
        MainView().environmentObject(store)
      } else {
        ProgressView()
          .accessibilityIdentifier("app-is-loading-indicator")
          .task(priority: .userInitiated) { await setup() }
      }
    }
  }

  @State private var isReady = false
  private let store: StoreOf<MainReducer>
  @StateObject private var viewStore: ViewStoreOf<MainReducer>
  @Dependency(\.authenticationService) private var authService

  init() {
    let store = Store(initialState: .init(), reducer: MainReducer())
    self.store = store
    _viewStore = StateObject(wrappedValue: ViewStoreOf<MainReducer>(store))
  }

  @MainActor private func setup() async {
    // private database
    viewStore.send(.privateDatabase(.projects(.enableUpdates)))
    viewStore.send(.privateDatabase(.items(.enableUpdates)))
    viewStore.send(.privateDatabase(.enableIndexing))
    
    // public database
    viewStore.send(.publicDatabase(.enableUpdates))
    viewStore.send(.publicDatabase(.projects(.enableUpdates)))
    viewStore.send(.publicDatabase(.items(.enableUpdates)))
    viewStore.send(.publicDatabase(.comments(.enableUpdates)))
    viewStore.send(.publicDatabase(.users(.enableUpdates)))
    viewStore.send(.publicDatabase(.friendships(.enableUpdates)))
    
    // misc
    viewStore.send(.account(.enableUpdates))
    viewStore.send(.notifications(.enableUpdates))
    viewStore.send(.iap(.enableUpdates))
    
    while authService.status == nil { await sleep(for: .nanoseconds(100)) }
    
    isReady = true
  }
}
