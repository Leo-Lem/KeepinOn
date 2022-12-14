// Created by Leopold Lemmermann on 17.12.22.

import SwiftUI

enum SizeClass {
  case compact
  case regular
  
  struct Key: EnvironmentKey { static let defaultValue = SizeClass.regular }
}

extension EnvironmentValues {
  var size: SizeClass {
    get { self[SizeClass.Key.self] }
    set { self[SizeClass.Key.self] = newValue }
  }
}
