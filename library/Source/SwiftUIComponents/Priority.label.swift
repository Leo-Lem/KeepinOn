// Created by Leopold Lemmermann on 22.02.25.

import Data

public extension Priority {
  var label: String {
    switch self {
    case .flexible: String(localizable: .priority1)
    case .prioritized: String(localizable: .priority2)
    case .urgent: String(localizable: .priority3)
    }
  }
}
