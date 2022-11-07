//	Created by Leopold Lemmermann on 25.10.22.

import SwiftUI

struct SharedItemsView: View {
  let state: LoadState<Item.Shared>

  var body: some View {
    switch state {
    case let .loading(items):
      let sorted = items.sorted { first, _ in !first.isDone }
      ForEach(sorted, content: Row.init)
      ProgressView()
        .frame(maxWidth: .infinity)
    case let .loaded(items) where items.isEmpty:
      Text("NO_ITEMS_PLACEHOLDER")
    case let .loaded(items):
      let sorted = items.sorted { first, _ in !first.isDone }
      ForEach(sorted, content: Row.init)
    #if DEBUG
      case let .failed(error):
        Text(error?.localizedDescription ?? "")
    #endif
    default:
      ProgressView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }

  struct Row: View {
    let item: Item.Shared

    var body: some View {
      HStack {
        Image(systemName: item.isDone ? "checkmark.circle" : "circle")
          .if(!item.isDone) { $0.foregroundColor(.clear) }

        VStack(alignment: .leading) {
          Text(item.label)
            .font(.default(.headline))

          if !item.details.isEmpty {
            Text(item.details)
          }
        }
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct SharedItemsView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SharedItemsView(state: .idle)
        .previewDisplayName("Idle")

      List {
        SharedItemsView(state: .loading([.example, .example]))
      }
      .listStyle(.plain)
      .previewDisplayName("Loading")

      List {
        SharedItemsView(state: .loaded([.example, .example]))
      }
      .listStyle(.plain)
      .previewDisplayName("Loaded")

      SharedItemsView(state: .failed(PublicDatabaseError.UserRelevancyReason.noNetwork))
        .previewDisplayName("Failed")
    }
    .padding()
    .configureForPreviews()
  }
}
#endif
