//	Created by Leopold Lemmermann on 21.10.22.

import SwiftUI
import LeosMisc

extension Project {
  var label: String { title ??? String(localized: "PROJECT_DEFAULTNAME") }
  var detailsLabel: String { details ??? String(localized: "PROJECT_DETAILS_PLACEHOLDER") }
  var color: Color { colorID.color }
  
  func a11y(_ items: [Item]) -> LocalizedStringKey {
    "A11Y_PROJECT \(Text("ITEMS \(items.count)")) \(items.progressLabel)"
  }
}

extension Array where Element == Item {
  var progress: Double { isEmpty ? 0 : Double(filter(\.isDone).count) / Double(count) }
  
  var progressLabel: String {
    Decimal(progress).formatted(.percent)
  }
}
