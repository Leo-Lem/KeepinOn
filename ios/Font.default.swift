//	Created by Leopold Lemmermann on 05.11.22.

import SwiftUI
import UIKit

@available(iOS 14, *)
extension Font {
  static func `default`(_ style: UIFont.TextStyle = .body) -> Font {
    .custom(Config.style.fontName, size: UIFont.preferredFont(forTextStyle: style).pointSize)
  }
}
