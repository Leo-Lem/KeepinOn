//  Created by Leopold Lemmermann on 09.10.22.

import SwiftUI

struct EditItemView: View {
  var body: some View {
    Text("Edit Item View")
  }

  @StateObject private var vm: ViewModel

  init(_ item: Item, appState: AppState) {
    _vm = StateObject(wrappedValue: ViewModel(item: item, appState: appState))
  }
}

// MARK: - (Previews)

struct EditItemView_Previews: PreviewProvider {  
  static var previews: some View {
    Group {
      EditItemView(.example, appState: .example)
        .previewDisplayName("Bare")

      SheetView.Preview {
        EditItemView(.example, appState: .example)
      }
      .previewDisplayName("Sheet")
    }
    .configureForPreviews()
  }
}
