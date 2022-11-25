//  Created by Leopold Lemmermann on 24.10.22.

import SwiftUI
import LeosMisc

@main struct Main: App {
  var body: some Scene {
    WindowGroup {
      AppView()
        .awaitSetup { await MainState() } placeholder: {
          ProgressView()
        }
    }
  }
}
