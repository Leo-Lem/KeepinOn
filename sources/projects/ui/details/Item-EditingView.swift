//  Created by Leopold Lemmermann on 09.10.22.

import LeosMisc
import SwiftUI

extension Item {
  struct EditingView: View {
    let id: Item.ID

    var body: some View {
      Form {
        Section("") { Item.EditDescriptionMenu(id: id)}
        Section("PRIORITY") { Item.PickPriorityMenu(id: id) }
        Section { Item.ToggleMenu(id: id) }
      }
      .formStyle(.grouped)
      .navigationTitle("EDIT_ITEM")
#if os(iOS)
        .compactDismissButtonToolbar()
        .embedInNavigationStack()
#endif
        .presentationDetents([.fraction(0.7)])
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct EditItemView_Previews: PreviewProvider {
  static var previews: some View {
    Item.EditingView(id: Item.example.id)
      .presentPreview(inContext: true)
  }
}
#endif
