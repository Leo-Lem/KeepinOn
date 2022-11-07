//	Created by Leopold Lemmermann on 18.10.22.

protocol PurchaseService: ObservableService {
  func getPurchase(id: Purchase.ID) -> Purchase
  func isPurchased(id: Purchase.ID) -> Bool
  func purchase(id: Purchase.ID) async -> Purchase.Result
}
