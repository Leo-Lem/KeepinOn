//	Created by Leopold Lemmermann on 05.11.22.

import SwiftUI

extension Font {
  static func `default`(_ style: UIFont.TextStyle = .body) -> Font {
    .custom(config.style.fontName, size: UIFont.preferredFont(forTextStyle: style).pointSize)
  }
}
