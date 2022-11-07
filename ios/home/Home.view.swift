//	Created by Leopold Lemmermann on 07.10.22.

import SwiftUI

struct HomeView: View {
  var body: some View {
    Text("Home view")
  }

  @StateObject private var vm: ViewModel

  init(appState: AppState) {
    _vm = StateObject(wrappedValue: ViewModel(appState: appState))
  }
}

// MARK: - (PREVIEWS)

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      HomeView(appState: .example)
        .previewDisplayName("Bare")

      NavigationStack { HomeView(appState: .example) }
        .previewDisplayName("Navigation")
    }
    .configureForPreviews()
  }
}
