//	Created by Leopold Lemmermann on 06.11.22.

import SwiftUI

extension PreferenceKey where Value: Equatable {
  static func reduce(value: inout Value, nextValue: () -> Value) {
    let nextValue = nextValue()
    value = nextValue == Self.defaultValue ? value : nextValue
  }
}

extension View {
  func preferred<S: Style>(
    style: S
  ) -> some View where S == S.Key.Value {
    preference(key: S.Key.self, value: style)
  }
}

extension View {
  func onPreferenceChange<S: Style>(
    update binding: Binding<S>
  ) -> some View where S == S.Key.Value, S: Equatable {
    onPreferenceChange(S.Key.self) { binding.wrappedValue = $0 }
  }
}
