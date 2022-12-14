//	Created by Leopold Lemmermann on 29.10.22.

import SwiftUI

enum Config {
  static let freeLimits = (projects: 3, items: 5),
             quickActionPrefix = "portfolio://",
             id = (
               group: "group.LeoLem.KeepinOn",
               cloudKit: "iCloud.LeoLem.KeepinOn"
             ),
             style = (
               fontName: "American Typewriter",
               background: Color.defaultBackgroundColor
             )

  static var containerURL: URL {
    FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Config.id.group)!
  }
  
  static var appname: String {
    (Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String)!
  }
}

@available(iOS 14, macOS 11, *)
extension Font {
  static func `default`(_ style: XKitFont.TextStyle = .body) -> Font {
    .custom(Config.style.fontName, size: XKitFont.preferredFont(forTextStyle: style).pointSize)
  }
}
