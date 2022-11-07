//	Created by Leopold Lemmermann on 07.10.22.

import SwiftUI

struct PurchasingView: View {
  var body: some View {
    VStack {
      Spacer()

      switch vm.purchaseState {
      case .loading:
        ProgressView("IAP_LOADING")
      case let .loaded(purchase):
        PurchasingView.PurchaseView(purchase: purchase) { purchase in
          Task(priority: .userInitiated) { await vm.purchase(purchase) }
        }
      case .success:
        Text("IAP_SUCCESSFUL")
      case .pending:
        Text("IAP_PENDING")
      case .failed:
        Text("IAP_ERROR")
      }

      Spacer()
    }
    .padding()
    .preferred(style: SheetViewStyle(size: .fraction(0.4)))
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
