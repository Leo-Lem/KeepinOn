//	Created by Leopold Lemmermann on 20.10.22.

import Foundation

extension Purchase: HasExample {
  static var example: Purchase {
    let price: Double = round(100 * Double.random(in: 1 ..< 20)) / 100
    
    return Purchase(
      id: .allCases.randomElement() ?? .fullVersion,
      name: .random(in: 10 ..< 25, using: .letters),
      desc: .random(in: 15 ..< 50, using: .letters.union(.whitespaces)) + ".",
      price: "\(price)$",
      rawPrice: price
    )
  }
}
