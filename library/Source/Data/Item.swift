//  Created by Leopold Lemmermann on 05.10.22.

import struct Foundation.Date

public struct Item: Codable, Equatable, Sendable, Identifiable {
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
    projectId: Int64 = 0,
    title: String = "",
    details: String = "",
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
  public static let project = belongsTo(Project.self)
}

extension Item: FetchableRecord {
  public struct WithProject: Sendable, Codable, Identifiable, Equatable, FetchableRecord {
    public var item: Item
    public var project: Project

    public var id: Int64? { item.id }

    public init(
      _ item: Item = Item(),
      project: Project = Project()
    ) {
      self.item = item
      self.project = project
    }
  }
}
