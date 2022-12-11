//	Created by Leopold Lemmermann on 05.10.22.

import Foundation

struct Item: Identifiable, Equatable, Hashable, Codable {
  let id: UUID, timestamp: Date

  var title: String,
      details: String,
      isDone: Bool,
      priority: Priority,
      project: Project.ID

  init(
    id: ID = ID(),
    timestamp: Date = .now,
    title: String = "",
    details: String = "",
    isDone: Bool = false,
    priority: Priority = .low,
    project: Project.ID
  ) {
    self.id = id
    self.timestamp = timestamp
    self.title = title
    self.details = details
    self.isDone = isDone
    self.priority = priority
    self.project = project
  }
}

extension Item {
  enum Priority: Int, CaseIterable, Equatable, Codable, Comparable {
    case low = 1, mid, high
    
    static func < (lhs: Self, rhs: Self) -> Bool { lhs.rawValue < rhs.rawValue }
  }
}
