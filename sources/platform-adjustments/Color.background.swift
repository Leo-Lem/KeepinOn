// Created by Leopold Lemmermann on 08.12.22.

import SwiftUI

extension Color {
  #if os(iOS)
  static let defaultBackgroundColor = Color(.systemGroupedBackground)
  #elseif os(macOS)
  static let defaultBackgroundColor = Color(.windowBackgroundColor)
  #endif
}
