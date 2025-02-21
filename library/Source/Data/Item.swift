//  Created by Leopold Lemmermann on 05.10.22.

import struct Foundation.Date

public struct Item: Codable, Equatable, Sendable {
  public var id: Int64?
  public var createdAt: Date?
  public var projectId: Int64

  public var title: String
  public var details: String
  public var priority: Priority
  public var done: Bool

  public init(
    id: Int64? = nil,
    createdAt: Date? = nil,
    projectId: Int64,
    title: String,
    details: String,
    priority: Priority = .flexible,
    done: Bool = false
  ) {
    self.id = id
    self.createdAt = createdAt
    self.projectId = projectId
    self.title = title
    self.details = details
    self.priority = priority
    self.done = done
  }
}

extension Item: MutablePersistableRecord {
  public mutating func willInsert(_ db: Database) throws {
    if createdAt == nil { createdAt = try db.transactionDate }
  }

  public mutating func didInsert(_ inserted: InsertionSuccess) {
    id = inserted.rowID
  }
}

extension Item: TableRecord {
  static let project = belongsTo(Project.self)
}

extension Item: FetchableRecord {
}

extension Item {
  static func migrate(_ migrator: inout DatabaseMigrator) {
    migrator.registerMigration("Create item table") { db in
      try db.create(table: "item") { t in
        t.autoIncrementedPrimaryKey("id")
        t.belongsTo("project", onDelete: .cascade).notNull()
        t.column("createdAt", .datetime).notNull()
        t.column("title", .text).notNull()
        t.column("details", .text).notNull()
        t.column("priority", .integer).notNull()
        t.column("done", .boolean).notNull().defaults(to: false)
      }
    }
  }
}
