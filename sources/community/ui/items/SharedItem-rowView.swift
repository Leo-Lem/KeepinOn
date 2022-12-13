//	Created by Leopold Lemmermann on 22.11.22.

import SwiftUI

extension SharedItem {
  func rowView() -> some View { RowView(self) }

  struct RowView: View {
    let item: SharedItem

    var body: some View {
      HStack {
        Image(systemName: item.isDone ? "checkmark.circle" : "circle")

        VStack(alignment: .leading) {
          Text(item.label)
            .font(.default(.headline))

          if !item.details.isEmpty {
            Text(item.details)
          }
        }
      }
      .accessibilityElement(children: .ignore)
      .accessibilityLabel("A11Y_SHAREDITEM")
      .accessibilityValue(item.a11y)
    }
    
    init(_ item: SharedItem) { self.item = item }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct SharedItemRowView_Previews: PreviewProvider {
    static var previews: some View {
      SharedItem.example.rowView()
        
    }
  }
#endif
