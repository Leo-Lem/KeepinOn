//  Created by Leopold Lemmermann on 24.10.22.

import SwiftUI

@main
struct AppEntry: App {
  @State private var appState: AppState?

  var body: some Scene {
    WindowGroup {
      if let appState = appState {
        AppView(appState: appState)
          .environmentObject(appState)
      } else {
        ProgressView()
          .task {
            self.appState = await AppState()
          }
      }
    }
  }
}
