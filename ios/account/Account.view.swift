//	Created by Leopold Lemmermann on 07.10.22.

import SwiftUI

struct AccountView: View {
  var body: some View {
    Text("Account View")
  }

  @StateObject private var vm: ViewModel

  init(appState: AppState) {
    _vm = StateObject(wrappedValue: ViewModel(appState: appState))
  }
}

// MARK: - (PREVIEWS)

struct AccountView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      AccountView(appState: .example)
        .previewDisplayName("Bare")

      SheetView.Preview { AccountView(appState: .example) }
        .previewDisplayName("Sheet")
    }
    .configureForPreviews()
  }
}
