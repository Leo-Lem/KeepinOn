//	Created by Leopold Lemmermann on 21.10.22.

import SwiftUI

extension Project {
  var label: String {
    String(localized: .init(title ??? "PROJECT_DEFAULTNAME"))
  }

  var detailsLabel: String {
    String(localized: .init(details ??? "PROJECT_DETAILS_PLACEHOLDER"))
  }

  var progress: Double {
    guard !items.isEmpty else { return 0 }

    let completed = items.filter(\.isDone)
    return Double(completed.count) / Double(items.count)
  }

  var a11y: LocalizedStringKey {
    "A11Y_COMPLETE_DESCRIPTION \(label) \(items.count) \(progress)"
  }

  var color: Color {
    colorID.color
  }
}
