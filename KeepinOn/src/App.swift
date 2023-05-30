// Created by Leopold Lemmermann on 30.05.2023.

import class ComposableArchitecture.Store
import SwiftUI

@main
struct App: SwiftUI.App {
  var body: some Scene {
    WindowGroup {
      AppView()
        .environmentObject(store)
    }
  }

  private let store = Store(initialState: .init(), reducer: AppReducer.init)
}
