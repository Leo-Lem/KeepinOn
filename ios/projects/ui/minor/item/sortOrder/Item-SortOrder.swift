//	Created by Leopold Lemmermann on 10.10.22.

import LeosMisc

extension Item {
  enum SortOrder: String, CaseIterable, Codable, Hashable {
    case optimized, title, timestamp
  }
}

extension Array where Element == Item {
  func sorted(using sortOrder: Item.SortOrder) -> [Item] {
    switch sortOrder {
    case .title:
      return sorted {
        ($0.title ??? "_").localizedCaseInsensitiveCompare($1.title ??? "_") == .orderedAscending
      }
    case .timestamp:
      return sorted(by: \.timestamp, using: >)
    case .optimized:
      return sorted {
        if !$0.isDone, $1.isDone {
          return true
        } else if $0.isDone, !$1.isDone {
          return false
        }

        if $0.priority > $1.priority {
          return true
        } else if $0.priority < $1.priority {
          return false
        }

        return $0.timestamp < $1.timestamp
      }
    }
  }
}
