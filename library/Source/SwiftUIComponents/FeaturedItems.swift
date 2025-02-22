// Created by Leopold Lemmermann on 22.02.25.

import Data

public struct FeaturedItems: View {
  let items: [Item.WithProject]

  public var body: some View {
    VStack {
      Text(.localizable(.items))
        .foregroundColor(.secondary)
        .padding(.top)

      ForEach(items, id: \.item.id) { item in
        ItemPeek(item.item, accent: item.project.accent)
          .background(item.project.accent.color.opacity(0.2), in: .capsule)
          .transition(.slide)
      }
    }
  }

  public init(_ items: [Item.WithProject]) { self.items = items }
}

#Preview {
  FeaturedItems([.init(.example(), project: .example()), .init(.example(), project: .example())])
}
