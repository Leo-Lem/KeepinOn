//	Created by Leopold Lemmermann on 10.11.22.

import SwiftUI

extension Item.SortOrder {
  var label: String {
    switch self {
    case .optimized: return String(localized: "OPTIMIZED_SORT")
    case .title: return String(localized: "CREATIONDATE_SORT")
    case .timestamp: return String(localized: "TITLE_SORT")
    }
  }
  
  mutating func next() {
    switch self {
    case .optimized: self = .title
    case .title: self = .timestamp
    case .timestamp: self = .optimized
    }
  }
}
