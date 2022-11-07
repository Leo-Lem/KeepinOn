//	Created by Leopold Lemmermann on 18.10.22.

import SwiftUI

extension ButtonStyle where Self == PurchaseButtonStyle {
  static var purchase: Self { .init() }
}

struct PurchaseButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(minWidth: 200, minHeight: 44)
      .background(Color.accentColor)
      .clipShape(Capsule())
      .opacity(configuration.isPressed ? 0.5 : 1)
  }
}
