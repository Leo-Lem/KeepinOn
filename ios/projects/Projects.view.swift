//  Created by Leopold Lemmermann on 09.10.2022.

import SwiftUI

struct ProjectsView: View {
  var body: some View {
    Text("Projects View")
  }

  @StateObject private var vm: ViewModel

  init(closed: Bool, appState: AppState) {
    _vm = StateObject(wrappedValue: ViewModel(closed: closed, appState: appState))
  }

}

// MARK: - (Previews)

struct ProjectsView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NavigationStack { ProjectsView(closed: false, appState: .example) }
        .previewDisplayName("Open")

      NavigationStack { ProjectsView(closed: true, appState: .example) }
        .previewDisplayName("Closed")
    }
    .configureForPreviews()
  }
}
