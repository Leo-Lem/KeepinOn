//	Created by Leopold Lemmermann on 28.11.22.

import SwiftUI
import AppKit

@available(macOS 11, *)
extension Font {
  static func `default`(_ style: NSFont.TextStyle = .body) -> Font {
    .custom(Config.style.fontName, size: NSFont.preferredFont(forTextStyle: style).pointSize)
  }
}
