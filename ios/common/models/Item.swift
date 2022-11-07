//	Created by Leopold Lemmermann on 05.10.22.

import Foundation

struct Item: Identifiable, Hashable, Codable {
  let id: UUID, timestamp: Date

  var title: String,
      details: String,
      isDone: Bool,
      priority: Priority,
      project: Project?

  init(
    id: UUID = UUID(),
    timestamp: Date = .now,
    title: String = "",
    details: String = "",
    isDone: Bool = false,
    priority: Priority = .low,
    project: Project? = nil
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
  enum Priority: Int, CaseIterable, Equatable, Codable {
    case low = 1, mid, high
  }
}

extension Item.Priority: Comparable {
  static func < (lhs: Self, rhs: Self) -> Bool { lhs.rawValue < rhs.rawValue }
}
