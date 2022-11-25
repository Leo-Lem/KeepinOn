//	Created by Leopold Lemmermann on 21.10.22.

import SwiftUI
import LeosMisc

extension Project {
  var label: String {
    String(localized: .init(title ??? "PROJECT_DEFAULTNAME"))
  }

  var detailsLabel: String {
    String(localized: .init(details ??? "PROJECT_DETAILS_PLACEHOLDER"))
  }

  var color: Color {
    colorID.color
  }
}
