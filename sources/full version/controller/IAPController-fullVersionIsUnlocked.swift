//	Created by Leopold Lemmermann on 04.12.22.

import InAppPurchaseService
import Errors

extension IAPController {
  func getFullVersionIsUnlocked() -> Bool { service.isPurchased(with: .fullVersion) }
  
  @MainActor func setFullVersionIsUnlocked(on change: PurchaseEvent<PurchaseID>) async {
    printError {
      switch change {
      case let .purchased(purchase):
        if case .fullVersion = purchase.id {
          fullVersionIsUnlocked = true
          eventPublisher.send(.unlockedFullVersion)
        }
      default:
        fullVersionIsUnlocked = getFullVersionIsUnlocked()
      }
    }
  }
}
