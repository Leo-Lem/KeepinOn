//	Created by Leopold Lemmermann on 24.10.22.

import LeosMisc
import SwiftUI

extension SharedItem {
  var label: String { title ??? String(localized: "ITEM_DEFAULTNAME") }
  
  var a11y: Text {
    Text(isDone ? "A11Y_SHAREDITEM_COMPLETED \(label)" : "A11Y_SHAREDITEM_NOTCOMPLETED \(label)")
  }
}
