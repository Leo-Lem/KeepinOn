// Created by Leopold Lemmermann on 22.02.25.

public func previews() -> (projects: [Project], items: [Item]) {
  // swiftlint:disable all
  let _ = prepareDependencies {
    $0.defaultDatabase = .keepinOn(inMemory: true)
  }

  @Dependency(\.defaultDatabase) var db
  var projects = [Project]()
  var items = [Item]()

#if DEBUG
  do {
    let _ = try db.write {
      for id in 0..<10 {
        var project = Project.example(id)
        try project.save($0)
        var item = Item.example(id, projectId: project.id)
        try item.save($0)

        projects.append(project)
        items.append(item)
      }
    }
  } catch {
    print(error)
  }
#endif

  return (projects, items)
  // swiftlint:enable all
}

public extension Project {
  static func example(_ index: Int = .random(in: 0..<100)) -> Project {
    Project(
      id: Int64(index),
      createdAt: .now,
      title: "Project \(index)",
      details: "This is an example project.\nIt has an index of \(index).\nAnd It has more information here.",
      accent: index.isMultiple(of: 3) ? .green : index.isMultiple(of: 2) ? .blue : .red,
      closed: index.isMultiple(of: 2)
    )
  }
}

public extension Item {
  static func example(_ index: Int = .random(in: 0..<100), projectId: Int64? = nil) -> Item {
    Item(
      id: Int64(index),
      createdAt: .now,
      projectId: projectId ?? Int64(index),
      title: "Item \(index)",
      details: "This is an example item.\nIt has an index of \(index).",
      priority: index.isMultiple(of: 3) ? .urgent : index.isMultiple(of: 2) ? .prioritized : .flexible,
      done: index.isMultiple(of: 2)
    )
  }
}
