//  Created by Leopold Lemmermann on 07.10.22.

import struct Foundation.Date
import SharingGRDB

public struct Project: Codable, Equatable, Sendable {
  public var id: Int64?
  public var createdAt: Date?

  public var title: String
  public var details: String
  public var accent: Accent
  public var closed: Bool

  public init(
    id: Int64? = nil,
    createdAt: Date? = nil,
    title: String = "",
    details: String = "",
    accent: Accent = .blue,
    closed: Bool = false
  ) {
    self.id = id
    self.createdAt = createdAt
    self.title = title
    self.details = details
    self.accent = accent
    self.closed = closed
  }
}

extension Project: MutablePersistableRecord {
  public mutating func willInsert(_ db: Database) throws {
    if createdAt == nil { createdAt = try db.transactionDate }
  }

  public mutating func didInsert(_ inserted: InsertionSuccess) {
    id = inserted.rowID
  }
}

extension Project: TableRecord {
  public static let items = hasMany(Item.self)
  public var items: QueryInterfaceRequest<Item> { request(for: Project.items) }
}

extension Project: FetchableRecord {
  public struct WithItems: Codable, FetchableRecord {
    public var project: Project
    public var items: [Item]

    public init(_ project: Project, items: [Item]) {
      self.project = project
      self.items = items
    }
  }

  /// Share of completed items.
  public func progress(_ db: Database) -> Double {
    do {
      let done = Double(try items.filter(Column("done") == false).fetchCount(db))
      let total = Double(try items.fetchCount(db))
      return total > 0 ? done / total : 0
    } catch {
      assertionFailure(error.localizedDescription)
      return 0
    }
  }
}

extension Project {
  static func migrate(_ migrator: inout DatabaseMigrator) {
    migrator.registerMigration("Create project table") { db in
      try db.create(table: "project") { t in
        t.autoIncrementedPrimaryKey("id")
        t.column("createdAt", .datetime).notNull()
        t.column("title", .text).notNull()
        t.column("details", .text).notNull()
        t.column("accent", .text).notNull()
        t.column("closed", .boolean).notNull().defaults(to: false)
      }
    }
  }
}
