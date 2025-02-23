//  Created by Leopold Lemmermann on 07.10.22.

import struct Foundation.Date
import SharingGRDB

public struct Project: Codable, Equatable, Sendable, Identifiable {
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

public extension Project {
  struct Draft {
    public var title: String
    public var details: String
    public var accent: Accent
    public var closed: Bool

    public init(
      title: String = "",
      details: String = "",
      accent: Accent = .blue,
      closed: Bool = false
    ) {
      self.title = title
      self.details = details
      self.accent = accent
      self.closed = closed
    }
  }
}

extension Project: MutablePersistableRecord, TableRecord, FetchableRecord {
  public mutating func willInsert(_ db: Database) throws {
    if createdAt == nil { createdAt = try db.transactionDate }
  }

  public mutating func didInsert(_ inserted: InsertionSuccess) {
    id = inserted.rowID
  }

  public static let items = hasMany(Item.self)
  public var items: QueryInterfaceRequest<Item> { request(for: Project.items) }

  public struct WithItems: Sendable, Codable, Identifiable, Equatable, FetchableRecord {
    public var project: Project
    public var items: [Item]

    public var id: Int64? { project.id }

    public init(
      _ project: Project = Project(),
      items: [Item] = []
    ) {
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
