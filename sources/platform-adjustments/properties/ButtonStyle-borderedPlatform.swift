// Created by Leopold Lemmermann on 17.12.22.

import SwiftUI

#if os(iOS)
extension PrimitiveButtonStyle where Self == BorderedProminentButtonStyle  {
  static func presentBordered() -> Self { .borderedProminent }
}
#elseif os(macOS)
extension PrimitiveButtonStyle where Self == BorderedButtonStyle  {
  static func presentBordered() -> Self { .bordered }
}
#endif
