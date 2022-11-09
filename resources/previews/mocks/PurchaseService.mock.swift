//	Created by Leopold Lemmermann on 20.10.22.

import Combine

final class MockPurchaseService: PurchaseService {
  let didChange = PassthroughSubject<Void, Never>()

  func getPurchase(id: Purchase.ID) -> Purchase {
    return .example
  }

  func isPurchased(id: Purchase.ID) -> Bool {
    return .random()
  }

  func purchase(id: Purchase.ID) async -> Purchase.Result {
    try? await Task.sleep(nanoseconds: 1000)
    return .success
  }
}
