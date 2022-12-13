//	Created by Leopold Lemmermann on 24.10.22.

import SwiftUI
import LeosMisc

extension SharedProject {
  var label: String { title ??? String(localized: "PROJECT_DEFAULTNAME") }
  
  func a11y(_ ownerLabel: String?) -> Text {
    if let ownerLabel = ownerLabel {
      return Text("A11Y_SHAREDPROJECT_VALUE \(label) \(ownerLabel)")
    } else {
      return Text(label)
    }
  }
}
