//	Created by Leopold Lemmermann on 24.10.22.

import LeosMisc

extension SharedProject {
  var label: String {
    String(localized: .init(title ??? "PROJECT_DEFAULTNAME"))
  }
}
