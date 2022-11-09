//	Created by Leopold Lemmermann on 07.10.22.

import Foundation

extension Item: HasExample {
  static var example: Item {
      return Item(
      title: "Item No. \(Int.random(in: 1 ..< 100))",
      details: "This is an example item",
      isDone: .random(),
      priority: .allCases.randomElement() ?? .low,
      project: UUID()
    )
  }
}
