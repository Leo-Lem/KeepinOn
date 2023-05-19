//	Created by Leopold Lemmermann on 07.12.22.

import ComposableArchitecture
import LeosMisc
import SwiftUI

extension Item {
  struct ToggleMenu: View {
    let id: Item.ID
    
    var body: some View {
      WithEditableConvertibleViewStore(
        with: id, from: \.privateDatabase.items, loadWith: .init { .privateDatabase(.items($0)) }
      ) { vm in
        Unwrap(vm.convertible) { (item: Item) in
          Render(isDone: item.isDone) { await vm.send(.modify(\.isDone, !item.isDone)).finish() }
        }
      }
    }
    
    struct Render: View {
      let isDone: Bool
      let toggle: () async -> Void
      
      var body: some View {
        AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated, action: toggle) {
          isDone ?
            Label("UNCOMPLETE_ITEM", systemImage: "checkmark.circle.badge.xmark") :
            Label("COMPLETE_ITEM", systemImage: "checkmark.circle")
        }
        .tint(.green)
        .accessibilityIdentifier("toggle-item")
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ItemToggleMenu_Previews: PreviewProvider {
  static var previews: some View {
    List {
      Item.ToggleMenu.Render(isDone: true) {}
      Item.ToggleMenu.Render(isDone: false) {}
    }
  }
}
#endif
