// Created by Leopold Lemmermann on 22.02.25.

import ComposableArchitecture
import Data
import SwiftUIComponents

public struct ItemDetailView: View {
  @Bindable public var store: StoreOf<ItemDetail>

  public var body: some View {
    VStack {
      HStack {
        PriorityLabel(store.item.priority)
          .labelStyle(.iconOnly)
          .font(.headline)
          .bold()

        Text(store.item.title)
          .font(.largeTitle)
          .fontWeight(.heavy)
          .lineLimit(1)

        Image(systemName: store.item.done ? "checkmark.circle" : "circle")
          .font(.title)
          .fontWeight(.bold)
      }
      .padding()
      .frame(maxWidth: .infinity)
      .foregroundColor(store.projectWithItems.project.accent.color)
      .accessibilityAddTraits(.isHeader)
      .accessibilityIdentifier("item-detail-page-header")

      Text(store.item.details.replacing("\n", with: " "))
        .font(.title2)
        .fontWeight(.semibold)

      Divider()
        .frame(width: 200)

      ProjectPeek(store.projectWithItems)
        .padding()

      Spacer()

      if let createdAt = store.item.createdAt {
        Text(localizable: .createdAt(createdAt.formatted(date: .abbreviated, time: .shortened)))
          .padding()
          .font(.subheadline)
      }
    }
    .presentationDetents([.medium])
  }

  public init(_ store: StoreOf<ItemDetail>) { self.store = store }
}

#Preview {
  @Previewable @State var presented = true

  Grid {}
    .sheet(isPresented: $presented) {
      ItemDetailView(Store(initialState: ItemDetail.State(previews().items[0].id)) {
        ItemDetail()._printChanges()
      })
    }
}
