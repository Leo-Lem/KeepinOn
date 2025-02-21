// Created by Leopold Lemmermann on 21.02.25.

import struct Foundation.URL
@_exported import SharingGRDB

public func database(inMemory: Bool = false) throws -> any DatabaseWriter {
  var config = Configuration()
  config.foreignKeysEnabled = true
#if DEBUG
  config.prepareDatabase { db in
    db.trace(options: .profile) { print($0.expandedDescription) }
  }
#endif

  let database: any DatabaseWriter = if inMemory {
    try DatabaseQueue(configuration: config)
  } else {
    try DatabasePool(path: URL.documentsDirectory.appending(component: "db.sqlite").path(), configuration: config)
  }

  var migrator = DatabaseMigrator()
#if DEBUG
  migrator.eraseDatabaseOnSchemaChange = true
#endif
  Project.migrate(&migrator)
  Item.migrate(&migrator)
  try migrator.migrate(database)

  return database
}

#if DEBUG
public func previews() -> (projects: [Project], items: [Item]) {
  // swiftlint:disable all
  let _ = prepareDependencies {
    $0.defaultDatabase = try! database(inMemory: true)
  }

  @Dependency(\.defaultDatabase) var db
  var projects = [Project]()
  var items = [Item]()

  do {
    let _ = try db.write {
      for id in Int64.zero..<10 {
        var project = Project(id: id, title: "Project \(id)", details: "", accent: .green, closed: false)
        try project.save($0)
        var item = Item(id: id, projectId: project.id!, title: "Item \(id)", details: "Some details about this item.")
        try item.save($0)

        projects.append(project)
        items.append(item)
      }
    }
  } catch {
    print(error)
  }

  return (projects, items)
  // swiftlint:enable all
}
#endif
