//	Created by Leopold Lemmermann on 18.10.22.

import Foundation

extension PurchasingView {
  final class ViewModel: KeepinOn.ViewModel {
    @Published private(set) var purchaseState: PurchaseState = .loading

    override init(appState: AppState) {
      super.init(appState: appState)

      purchaseState = .loaded(purchaseService.getPurchase(id: .fullVersion))
    }
  }
}

extension PurchasingView.ViewModel {
  func purchase(_ id: Purchase.ID) async {
    purchaseState = .loading
    let result = await purchaseService.purchase(id: id)

    switch result {
    case .success:
      purchaseState = .success
      await printError { try await awardService.unlockedFullVersion() }
      await cancel(after: 5)
    case .pending:
      purchaseState = .pending
      await cancel(after: 5)
    case .cancelled:
      cancel()
    case .failed:
      purchaseState = .failed
      await cancel(after: 5)
    }
  }

  func cancel() {
    Task { await cancel(after: nil) }
  }

  func cancel(after seconds: UInt64?) async {
    if let seconds = seconds {
      try? await Task.sleep(nanoseconds: seconds * NSEC_PER_SEC)
    }
    routingService.dismiss(.sheet())
  }

  enum PurchaseState {
    case loaded(Purchase),
         loading,
         success,
         pending,
         failed
  }
}
