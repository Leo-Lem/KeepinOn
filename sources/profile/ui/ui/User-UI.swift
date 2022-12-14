//	Created by Leopold Lemmermann on 28.10.22.

import SwiftUI
import LeosMisc

extension User {
  var label: String { name ??? String(localized: "ANONYMOUS_USER") }
  var color: Color { colorID.color }
}
