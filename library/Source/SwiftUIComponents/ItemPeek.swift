// Created by Leopold Lemmermann on 22.02.25.

import Data

public struct ItemPeek: View {
  let item: Item
  let accent: Accent

  public var body: some View {
    HStack(spacing: 20) {
      Image(systemName: item.icon)
        .font(.title)
        .imageScale(.large)
        .foregroundColor(accent.color)
        .shadow(color: accent.color, radius: 1)
        .accessibilityLabel(item.a11y)

      VStack(alignment: .leading) {
        Text(item.title)
          .lineLimit(1)
          .font(.title2)
          .foregroundColor(.primary)

        if !item.details.isEmpty {
          Text(item.details)
            .lineLimit(1)
            .foregroundColor(.secondary)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .cornerRadius(10)
    .accessibilityElement(children: .ignore)
    .accessibilityLabel(item.a11y)
    .accessibilityValue(item.title)
  }

  public init(_ item: Item, accent: Accent) {
    self.item = item
    self.accent = accent
  }
}

#Preview {
  ItemPeek(.example(), accent: .green)
}
