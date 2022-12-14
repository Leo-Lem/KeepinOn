//  Created by Leopold Lemmermann on 09.10.22.

import ComposableArchitecture
import Errors
import LeosMisc
import Previews
import SwiftUI

extension Item {
  func editingView() -> some View { EditingView(self) }

  struct EditingView: View {
    let item: Item
    
    var body: some View {
      Form {
        Section("") { item.editingMenu(.description) }
        Section("PRIORITY") { item.editingMenu(.priority) }
        Section { item.editingMenu(.toggle) }
      }
      .formStyle(.grouped)
      .navigationTitle("EDIT_ITEM")
#if os(iOS)
        .compactDismissButtonToolbar()
        .embedInNavigationStack()
#endif
        .presentationDetents([.fraction(0.7)])
    }

    init(_ item: Item) { self.item = item }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct EditItemView_Previews: PreviewProvider {
  static var previews: some View {
    Item.EditingView(.example).presentPreview(inContext: true)
  }
}
#endif
