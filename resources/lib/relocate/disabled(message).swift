//	Created by Leopold Lemmermann on 27.11.22.

import SwiftUI

extension View {
  func disabled(
    _ disabled: Bool,
    message: LocalizedStringKey,
    action: (() -> Void)? = nil
  ) -> some View {
    self.disabled(disabled, message: Text(message), action: action)
  }

  @_disfavoredOverload
  func disabled<S: StringProtocol>(
    _ disabled: Bool,
    message: S,
    action: (() -> Void)? = nil
  ) -> some View {
    self.disabled(disabled, message: Text(message), action: action)
  }

  @ViewBuilder func disabled(
    _ disabled: Bool,
    message: Text?,
    action: (() -> Void)? = nil
  ) -> some View {
    if disabled {
      ZStack {
        self
          .disabled(true)
          .colorMultiply(.gray)

        if let message = message {
          Group {
            if let action = action { Button(action: action, label: { message }) } else { message }
          }
          .bold()
          .lineLimit(1)
          .padding()
          .background(Color.gray.opacity(0.8))
          .cornerRadius(10)
          .foregroundColor(.primary)
          .colorInvert()
          .rotationEffect(.degrees(-3))
        }
      }
      .accessibilityElement(children: .ignore)
      .if(action != nil) { $0.accessibilityAddTraits(.isButton) }
      .if(let: message) { $0.accessibilityLabel($1) }
    } else { self }
  }
}
