//	Created by Leopold Lemmermann on 10.11.22.

import SwiftUI

extension Item.SortOrder {
  var label: LocalizedStringKey {
    switch self {
    case .optimized: return "OPTIMIZED_SORT"
    case .title: return "CREATIONDATE_SORT"
    case .timestamp: return "TITLE_SORT"
    }
  }
}
