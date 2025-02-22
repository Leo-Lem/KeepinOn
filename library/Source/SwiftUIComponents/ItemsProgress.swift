// Created by Leopold Lemmermann on 22.02.25.

import Data

public struct ItemsProgress: View {
  let items: [Item]
  let accent: Accent

  public var body: some View {
    ProgressView(value: Double(items.filter { !$0.done }.count), total: Double(items.count))
      .progressViewStyle(.linear)
      .tint(accent.color)
      .shadow(color: accent.color, radius: 10)
  }

  public init(_ items: [Item], accent: Accent) {
    self.items = items
    self.accent = accent
  }
}

#Preview {
  ItemsProgress([.example(), .example(), .example()], accent: .blue)
}
