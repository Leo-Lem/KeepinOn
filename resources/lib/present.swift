// Created by Leopold Lemmermann on 09.12.22.

import LeosMisc
import SwiftUI

extension EnvironmentValues {
  var present: (Any?) -> Void {
    get { self[PresentationKey.self] }
    set { self[PresentationKey.self] = newValue }
  }
}

struct PresentationKey: EnvironmentKey {
  static let defaultValue: (Any?) -> Void = { _ in debugPrint("No presentor available.") }
}
