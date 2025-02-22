// Created by Leopold Lemmermann on 22.02.25.

import Data

public extension Accent {
  var a11y: String {
    switch self {
    case .red: String(localizable: .red)
    case .green: String(localizable: .green)
    case .blue: String(localizable: .blue)
    case .pink: String(localizable: .pink)
    case .purple: String(localizable: .purple)
    case .orange: String(localizable: .orange)
    case .teal: String(localizable: .teal)
    case .lightBlue: String(localizable: .lightBlue)
    case .gray: String(localizable: .gray)
    }
  }
}
