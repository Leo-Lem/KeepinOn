// Created by Leopold Lemmermann on 20.02.25.

import Data

public extension Accent {
  var color: Color {
    switch self {
    case .red: .red
    case .green: .green
    case .blue: .blue
    case .pink: .pink
    case .purple: .purple
    case .orange: .orange
    case .teal: .teal
    case .lightBlue: .blue.opacity(0.5)
    case .gray: .gray
    }
  }
}
