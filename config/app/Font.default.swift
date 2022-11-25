//	Created by Leopold Lemmermann on 05.11.22.

import SwiftUI
#if canImport(UIKit)
import UIKit

@available(iOS 14, *)
extension Font {
  static func `default`(_ style: UIFont.TextStyle = .body) -> Font {
    .custom(Config.style.fontName, size: UIFont.preferredFont(forTextStyle: style).pointSize)
  }
}

#elseif canImport(AppKit)
import AppKit

@available(macOS 11, *)
extension Font {
  static func `default`(_ style: NSFont.TextStyle = .body) -> Font {
    .custom(Config.style.fontName, size: NSFont.preferredFont(forTextStyle: style).pointSize)
  }
}

#endif
