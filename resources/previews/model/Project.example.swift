//	Created by Leopold Lemmermann on 07.10.22.

import CoreData

extension Project {
  static var example: Project {
    var project = Project(
      title: "Project No. \(Int.random(in: 1 ..< 100))",
      details: "This is an example project",
      isClosed: .random(),
      colorID: .allCases.randomElement() ?? .darkBlue,
      items: [Item(
        title: "Item No. \(Int.random(in: 1 ..< 100))",
        details: "This is an example item",
        isDone: .random(),
        priority: .allCases.randomElement() ?? .low
      ), Item(
        title: "Item No. \(Int.random(in: 1 ..< 100))",
        details: "This is an example item",
        isDone: .random(),
        priority: .allCases.randomElement() ?? .low
      ), Item(
        title: "Item No. \(Int.random(in: 1 ..< 100))",
        details: "This is an example item",
        isDone: .random(),
        priority: .allCases.randomElement() ?? .low
      )]
    )

    project.items = project.items.map { item in
      var item = item
      item.project = project
      return item
    }

    return project
  }
}
