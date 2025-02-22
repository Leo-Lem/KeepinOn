// Created by Leopold Lemmermann on 20.02.25.

import Data

public extension Accent {
  var color: Color {
    switch self {
    case .blue: .blue
    case .green: .green
    case .red: .red
    @unknown default: .blue
    }
  }
}
