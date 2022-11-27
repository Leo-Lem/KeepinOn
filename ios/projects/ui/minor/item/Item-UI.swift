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

extension Array where Element == Item {
  var progress: Double { Double(isEmpty ? 0 : filter(\.isDone).count / count) }
  
  var progressLabel: String {
    Decimal(progress).formatted(.percent)
  }
}
