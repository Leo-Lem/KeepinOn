// Created by Leopold Lemmermann on 31.12.22.

import Previews
import SwiftUI

extension Item.Priority {
  struct SelectionMenu: View {
    @Binding var priority: Item.Priority
    
    var body: some View {
      Picker(
        String(localized: "PRIORITY"), selection: $priority, items: Item.Priority.allCases, id: \.self
      ) { priority in
        Text(priority.titleKey).tag(priority)
      }
      .pickerStyle(.segmented)
      .labelsHidden()
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ItemPrioritySelectionMenu_Previews: PreviewProvider {
  static var previews: some View {
    Binding.Preview(Item.Priority.mid) { binding in
      Item.Priority.SelectionMenu(priority: binding)
    }
  }
}
#endif
