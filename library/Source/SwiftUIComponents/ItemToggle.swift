// Created by Leopold Lemmermann on 23.02.25.

import Data
import SwiftUI

public struct ItemToggle: View {
  @Binding public var done: Bool

  public var body: some View {
    Toggle(
      .localizable(done ? .uncomplete : .complete),
      systemImage: done ? "checkmark.circle.badge.xmark" : "checkmark.circle",
      isOn: $done
    )
    .tint(done ? .yellow : .green)
    .accessibilityIdentifier("toggle-item")
  }

  public init(_ done: Binding<Bool>) { _done = done }
}

#Preview {
  @Previewable @State var done = false

  ItemToggle($done)
    .toggleStyle(.button)
}
