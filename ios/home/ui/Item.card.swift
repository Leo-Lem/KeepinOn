//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

struct ItemCard: View {
  let item: Item

  var body: some View {
    HStack(spacing: 20) {
      Image(systemName: item.icon)
        .font(.default(.title1))
        .imageScale(.large)
        .foregroundColor(item.color)
        .accessibilityLabel(item.a11y)

      VStack(alignment: .leading) {
        Text(item.label)
          .font(.default(.title2))
          .foregroundColor(.primary)

        if !item.details.isEmpty {
          Text(item.details)
            .foregroundColor(.secondary)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .background(Color(.secondarySystemGroupedBackground))
    .cornerRadius(10)
    .shadow(color: .primary.opacity(0.2), radius: 5)
  }

  init(_ item: Item) {
    self.item = item
  }
}

// MARK: - (Previews)

struct ItemCard_Previews: PreviewProvider {
  static var previews: some View {
    ItemCard(.example)
      .font(.default())
      .previewDisplayName("Simple")
  }
}
