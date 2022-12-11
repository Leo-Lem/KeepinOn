//	Created by Leopold Lemmermann on 27.10.22.

import SwiftUI

extension ColorID {
  public var asset: String {
    switch self {
    case .pink: return "Pink"
    case .purple: return "Purple"
    case .red: return "Red"
    case .orange: return "Orange"
    case .gold: return "Gold"
    case .green: return "Green"
    case .teal: return "Teal"
    case .lightBlue: return "Light Blue"
    case .darkBlue: return "Dark Blue"
    case .midnight: return "Midnight"
    case .darkGray: return "Dark Gray"
    case .gray: return "Gray"
    }
  }

  public var color: Color { Color(self.asset, bundle: .module) }

  @available(iOS 15, macOS 12, *)
  public var a11y: String {
    let key = String.LocalizationValue(asset.uppercased().replacingOccurrences(of: " ", with: "_"))
    return String(localized: key, bundle: .module)
  }
}
