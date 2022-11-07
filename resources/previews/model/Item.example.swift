//	Created by Leopold Lemmermann on 07.10.22.

extension Item {
  static var example: Item {
    var item = Item(
      title: "Item No. \(Int.random(in: 1 ..< 100))",
      details: "This is an example item",
      isDone: .random(),
      priority: .allCases.randomElement() ?? .low,
      project: Project(
        title: "Project No. \(Int.random(in: 1 ..< 100))",
        details: "This is an example project",
        isClosed: .random(),
        colorID: .allCases.randomElement() ?? .darkBlue
      )
    )
    var project = item.project
    project?.items = [item]
    item.project = project

    return item
  }
}
