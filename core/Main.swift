//  Created by Leopold Lemmermann on 24.10.22.

import LeosMisc
import SwiftUI

@main struct Main: App {
  var body: some Scene {
    WindowGroup {
      EntryView()
        .awaitSetup { await MainState() } placeholder: {
          ProgressView()
        }
    }
  }
}
