//	Created by Leopold Lemmermann on 30.10.22.

import Errors
import SwiftUI

extension Item {
  func rowView() -> some View { RowView(self) }

  struct RowView: View {
    let item: Item

    var body: some View {
      Label(title: Text(item.label).fixedSize) {
        Image(systemName: item.icon)
          .foregroundColor(project?.color)
          .accessibilityLabel(item.a11y)
      }
    }

    @EnvironmentObject private var mainState: MainState

    init(_ item: Item) { self.item = item }

    private var project: Project? {
      printError { try mainState.localDBService.fetch(with: item.project) }
    }
  }
}

// MARK: - (Previews)

#if DEBUG
  struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
      Item.example.rowView()
        .previewDisplayName("Simple")

      List {
        ForEach([Item.example, .example, .example], content: Item.RowView.init)
      }
      .previewDisplayName("List")
    }
  }
#endif
