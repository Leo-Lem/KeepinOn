//	Created by Leopold Lemmermann on 07.10.22.

import Foundation

extension Item: HasExample {
  static var example: Item {
    Item(
      title: .random(in: 5 ..< 20, using: .letters),
      details: .random(in: 15 ..< 50, using: .letters.union(.whitespacesAndNewlines)) + ".",
      isDone: .random(),
      priority: .allCases.randomElement() ?? .low,
      project: Project.example.id
    )
  }
}
