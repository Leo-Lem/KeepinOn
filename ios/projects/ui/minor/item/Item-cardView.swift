//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI
import Errors

extension Item {
  func cardView() -> some View { CardView(self) }

  struct CardView: View {
    let item: Item

    var body: some View {
      HStack(spacing: 20) {
        Image(systemName: item.icon)
          .font(.default(.title1))
          .imageScale(.large)
          .foregroundColor(project?.color)
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
      .background(Config.style.background)
      .cornerRadius(10)
      .shadow(color: .primary.opacity(0.2), radius: 5)
      .accessibilityElement(children: .ignore)
      .accessibilityLabel(item.a11y)
      .accessibilityValue(item.label)
    }

    @EnvironmentObject private var mainState: MainState

    init(_ item: Item) { self.item = item }

    private var project: Project? {
      printError { try mainState.localDBService.fetch(with: item.project) }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct ItemCard_Previews: PreviewProvider {
    static var previews: some View {
      Item.example.cardView()
        .previewDisplayName("Simple")
        .configureForPreviews()
    }
  }
#endif
