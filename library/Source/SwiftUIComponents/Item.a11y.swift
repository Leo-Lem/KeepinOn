// Created by Leopold Lemmermann on 22.02.25.

import Data

public extension Item {
  var a11y: String {
    switch true {
    case done: String(localizable: .a11yItemDone)
    case priority == .urgent: String(localizable: .a11yItemUrgent)
    default: String(localizable: .a11yItem)
    }
  }
}
