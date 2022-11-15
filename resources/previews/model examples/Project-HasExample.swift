//	Created by Leopold Lemmermann on 07.10.22.

import Foundation

extension Project: HasExample {
  static var example: Project {
    Project(
      title: .random(in: 5 ..< 20, using: .letters),
      details: .random(in: 15 ..< 50, using: .letters.union(.whitespacesAndNewlines)) + ".",
      isClosed: .random(),
      colorID: .example,
      items: [Item.ID(), Item.ID(), Item.ID()]
    )
  }
}
