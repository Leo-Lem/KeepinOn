//	Created by Leopold Lemmermann on 24.10.22.

import LeosMisc

extension SharedItem {
  var label: String {
    String(localized: .init(title ??? "ITEM_DEFAULTNAME"))
  }
}
