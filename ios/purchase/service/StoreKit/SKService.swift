//	Created by Leopold Lemmermann on 18.10.22.

import Combine
import StoreKit

final class SKService: PurchaseService {
  let didChange = PassthroughSubject<Void, Never>()

  private var products = Set<Product>() {
    didSet { didChange.send() }
  }
  private var purchasedProducts = Set<Product>() {
    didSet { didChange.send() }
  }

  private let tasks = Tasks()

  init() async {
    await getProducts()
    tasks.add(reactToUpdates())
  }

  func getPurchase(id: Purchase.ID) -> Purchase {
    Purchase(product: products.first { $0.id == id.rawValue }!)
  }

  func isPurchased(id: Purchase.ID) -> Bool {
    purchasedProducts.first { $0.id == id.rawValue } != nil
  }

  func purchase(id: Purchase.ID) async -> Purchase.Result {
    let product = products.first { $0.id == id.rawValue }!

    do {
      let result = try await product.purchase()
      return mapToPurchaseResult(result)
    } catch let error as Product.PurchaseError {
      return .failed(error)
    } catch {
      print("Failed to purchase product (\(product.debugDescription)): \(error.localizedDescription)")
      return .failed()
    }
  }
}

private extension SKService {
  func reactToUpdates() -> Task<Void, Never> {
    Task(priority: .background) {
      for await verificationResult in Transaction.updates {
        handle(transaction: verificationResult)
      }
    }
  }

  func getProducts() async {
    do {
      products = Set(try await Product.products(for: Purchase.ID.allCases.map(\.rawValue)))

      for product in products {
        if let verificationResult = await product.latestTransaction {
          handle(transaction: verificationResult)
        }
      }
    } catch {
      print("Failed to get products info: \(error.localizedDescription)")
    }
  }

  func handle(transaction: VerificationResult<Transaction>) {
    guard case let .verified(transaction) = transaction else { return }

    if transaction.revocationDate != nil {
      purchasedProducts = purchasedProducts.filter { $0.id != transaction.productID }
      didChange.send()
    } else if let expirationDate = transaction.expirationDate, expirationDate < Date() {
      return
    } else if transaction.isUpgraded {
      return
    } else if let product = products.first(where: { $0.id == transaction.productID }) {
      purchasedProducts.insert(product)
    }
  }

  func mapToPurchaseResult(_ result: Product.PurchaseResult) -> Purchase.Result {
    switch result {
    case let .success(verification):
      handle(transaction: verification)
      return .success
    case .pending:
      return .pending
    case .userCancelled:
      return .cancelled
    default:
      return .failed()
    }
  }
}
