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
               background: Color.background
             )

  static var containerURL: URL {
    FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Config.id.group)!
  }
  
  static var appname: String {
    (Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String)!
  }
}
