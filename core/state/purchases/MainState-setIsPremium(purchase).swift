//	Created by Leopold Lemmermann on 04.12.22.

import InAppPurchaseService
import AwardsService
import Errors

extension MainState {
  @MainActor func setIsPremium(on change: PurchaseEvent<PurchaseID>) async {
    await printError {
      switch change {
      case let .purchased(purchase):
        if case .fullVersion = purchase.id {
          hasFullVersion = true
          try await awardsService.notify(of: .becamePremium)
        }
        
      default:
        hasFullVersion = purchaseService.isPurchased(with: .fullVersion)
      }
    }
  }
}
