// Created by Leopold Lemmermann on 08.12.22.

import Previews

extension Project: HasExample {
  static var example: Project {
    Project(
      title: .random(in: 5 ..< 20, using: .letters).localizedCapitalized,
      details: .random(in: 15 ..< 50, using: .letters.union(.whitespacesAndNewlines)).localizedCapitalized + ".",
      isClosed: .random(),
      colorID: .example,
      items: [Item.ID(), Item.ID(), Item.ID()]
    )
  }
}

extension Item: HasExample {
  static var example: Item {
    Item(
      title: .random(in: 5 ..< 20, using: .letters).localizedCapitalized,
      details: .random(in: 15 ..< 50, using: .letters.union(.whitespacesAndNewlines)).localizedCapitalized + ".",
      isDone: .random(),
      priority: .allCases.randomElement() ?? .low,
      project: Project.example.id
    )
  }
}
