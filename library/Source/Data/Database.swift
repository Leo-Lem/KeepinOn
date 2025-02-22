// Created by Leopold Lemmermann on 21.02.25.

import struct Foundation.URL
@_exported import SharingGRDB

public extension DatabaseWriter where Self == DatabaseQueue {
  static func keepinOn(inMemory: Bool = false) -> Self {
    do {
      var config = Configuration()
      config.foreignKeysEnabled = true
#if DEBUG
      config.prepareDatabase { db in
        db.trace(options: .profile) { print($0.expandedDescription) }
      }
#endif

      let database: DatabaseQueue = if inMemory {
        try DatabaseQueue(configuration: config)
      } else {
        try DatabaseQueue(path: URL.documentsDirectory.appending(component: "db.sqlite").path(), configuration: config)
      }

      var migrator = DatabaseMigrator()
#if DEBUG
      migrator.eraseDatabaseOnSchemaChange = true
#endif
      Project.migrate(&migrator)
      Item.migrate(&migrator)
      try migrator.migrate(database)

      return database
    } catch { fatalError("Failed to set up database: \(error)")}
  }
}
