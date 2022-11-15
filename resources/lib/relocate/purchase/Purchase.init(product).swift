//	Created by Leopold Lemmermann on 20.10.22.

import StoreKit

extension Purchase {
  init(product: Product) {
    self.init(
      id: ID(rawValue: product.id)!,
      name: product.displayName,
      desc: product.description,
      price: product.displayPrice,
      rawPrice: Double(truncating: product.price as NSNumber)
    )
  }
}
