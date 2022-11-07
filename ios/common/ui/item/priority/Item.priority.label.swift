//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

extension Item.Priority {
  var label: LocalizedStringKey {
    switch self {
    case .low: return "PRIORITY_LOW"
    case .mid: return "PRIORITY_MID"
    case .high: return "PRIORITY_HIGH"
    }
  }
}
