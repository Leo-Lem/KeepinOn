// Created by Leopold Lemmermann on 20.05.23.

import struct Foundation.Date
import struct Foundation.UUID

struct Issue: Identifiable {
  let id = UUID()
  let timestamp = Date.now

  var title: String {
    didSet { update() }
  }
  
  var details: String?  {
    didSet { update() }
  }
  
  var priority: Priority {
    didSet { update() }
  }
  
  var isClosed = false
  
  private(set) var modifiedAt = Date.now
  
  private mutating func update() {
    isClosed = false
    modifiedAt = .now
  }
}

extension Issue {
  enum Priority: Int, Hashable {
    case low = 0, mid = 1, high = 2
  }
}

extension Issue.Priority: Comparable {
  static func < (lhs: Issue.Priority, rhs: Issue.Priority) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}
