//	Created by Leopold Lemmermann on 09.10.22.

import SwiftUI

public extension Button where Label == Image {
  init(
    systemImage: String,
    action: @escaping () -> Void
  ) {
    self.init(action: action) { Image(systemName: systemImage) }
  }
}
