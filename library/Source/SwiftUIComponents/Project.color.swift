// Created by Leopold Lemmermann on 20.02.25.

import Data
import SwiftUI

public extension Project {
  var color: Color {
    switch accent {
    case .blue: .blue
    case .green: .green
    case .red: .red
    @unknown default: .blue
    }
  }
}
