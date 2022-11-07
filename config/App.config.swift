//	Created by Leopold Lemmermann on 29.10.22.

import SwiftUI

struct Config<Background: ShapeStyle> {
  let freeProjectsLimit: Int,
      quickActionPrefix: String,
      groupID: String,
      style: Style<Background>

  struct Style<Background: ShapeStyle> {
    let fontName: String,
        background: Background
  }
}

let config = Config(
  freeProjectsLimit: 3,
  quickActionPrefix: "portfolio://",
  groupID: "group.LeoLem.KeepinOn",
  style: Config.Style(
    fontName: "American Typewriter",
    background: Color(.systemGroupedBackground)
  )
)

extension Config {
  var containerURL: URL {
    FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: config.groupID)!
  }
}
