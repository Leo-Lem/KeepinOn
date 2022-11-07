//	Created by Leopold Lemmermann on 07.10.22.

import SwiftUI

struct CommunityView: View {
  var body: some View {
    Text("Community View")
  }

  @StateObject private var vm: ViewModel

  init(appState: AppState) {
    _vm = StateObject(wrappedValue: ViewModel(appState: appState))
  }
}

// MARK: - (PREVIEWS)

struct CommunityView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      CommunityView(appState: .example)
        .previewDisplayName("Bare")

      NavigationStack { CommunityView(appState: .example) }
        .previewDisplayName("Navigation")
    }
    .configureForPreviews()
  }
}
