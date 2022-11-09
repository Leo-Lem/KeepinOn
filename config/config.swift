//	Created by Leopold Lemmermann on 29.10.22.

import SwiftUI

let config = Config(
  freeLimits: (projects: 3, items: 5),
  quickActionPrefix: "portfolio://",
  groupID: "group.LeoLem.KeepinOn",
  style: Config.Style(
    fontName: "American Typewriter",
    background: Color(.systemGroupedBackground)
  )
)

struct Config<Background: ShapeStyle> {
  let freeLimits: (projects: Int, items: Int),
      quickActionPrefix: String,
      groupID: String,
      style: Style<Background>

  struct Style<Background: ShapeStyle> {
    let fontName: String,
        background: Background
  }
}

extension Config {
  var containerURL: URL {
    FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID)!
  }
}
