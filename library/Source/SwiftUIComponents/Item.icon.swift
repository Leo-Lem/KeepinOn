// Created by Leopold Lemmermann on 20.02.25.

import Data
import SwiftUI

public extension Item {
  var icon: String {
    switch true {
    case done: "checkmark.circle"
    case priority == .urgent: "exclamationmark.triangle"
    default: "circle"
    }
  }
}
