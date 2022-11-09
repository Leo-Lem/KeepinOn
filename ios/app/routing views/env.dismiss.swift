//	Created by Leopold Lemmermann on 06.11.22.

import SwiftUI

struct DismissCustomKey: EnvironmentKey {
  static let defaultValue = {
    debugPrint("Cannot dismiss this view.")
  }
}

extension EnvironmentValues {
  var dismiss: () -> Void {
    get { self[DismissCustomKey.self] }
    set { self[DismissCustomKey.self] = newValue }
  }
}
