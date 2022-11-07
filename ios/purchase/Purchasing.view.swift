//	Created by Leopold Lemmermann on 07.10.22.

import SwiftUI

struct PurchasingView: View {
  var body: some View {
    Text("Purchasing View")
  }

  @StateObject private var vm: ViewModel

  init(appState: AppState) {
    _vm = StateObject(wrappedValue: ViewModel(appState: appState))
  }
}

// MARK: - (PREVIEWS)

struct PurchasingView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      PurchasingView(appState: .example)
        .previewDisplayName("Bar")

      SheetView.Preview { PurchasingView(appState: .example) }
        .previewDisplayName("Sheet")
    }
    .configureForPreviews()
  }
}
