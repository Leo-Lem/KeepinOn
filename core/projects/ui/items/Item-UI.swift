//	Created by Leopold Lemmermann on 21.10.22.

import SwiftUI
import LeosMisc

extension Item {
  var label: String {
    title ??? String(localized: "ITEM_DEFAULTNAME")
  }

  var detailsLabel: String {
    details ??? String(localized: "ITEM_DETAILS_PLACEHOLDER")
  }

  struct Icon {
    let name: String,
        a11y: LocalizedStringKey
  }

  var icon: String {
    switch self {
    case _ where isDone: return "checkmark.circle"
    case _ where priority == .high: return "exclamationmark.triangle"
    default: return "circle"
    }
  }
  
  var a11y: LocalizedStringKey {
    switch self {
    case _ where isDone: return "A11Y_ITEM_COMPLETED"
    case _ where priority == .high: return "A11Y_ITEM_PRIORITY"
    default: return ""
    }
  }
}

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
        ($0.title ??? "_")
          .localizedCaseInsensitiveCompare($1.title ??? "_") == .orderedAscending
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
