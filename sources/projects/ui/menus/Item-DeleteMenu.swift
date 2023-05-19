//	Created by Leopold Lemmermann on 07.12.22.

import ComposableArchitecture
import LeosMisc
import SwiftUI

extension Item {
  struct DeleteMenu: View {
    let id: Item.ID
    
    var body: some View {
      WithConvertibleViewStore(
        with: id, from: \.privateDatabase.items, loadWith: .init { .privateDatabase(.items($0))}
      ) { convertible in
        Unwrap(convertible) { (item: Item) in
          WithViewStore(store) { $0 } send: { (action: ViewAction) in
            switch action {
            case .removeItemFromProject:
              return .privateDatabase(.projects(.modifyWith(id: item.project) { $0.items.removeAll { $0 == id } }))
            case .deleteItem:
              return .privateDatabase(.items(.deleteWith(id: id)))
            }
          } content: { vm in
            Render {
              // TODO: delete shared
              await vm.send(.removeItemFromProject).finish()
              await vm.send(.deleteItem).finish()
            }
          }
        }
      }
    }
    
    @EnvironmentObject private var store: StoreOf<MainReducer>
      enum ViewAction { case removeItemFromProject, deleteItem }
    
    struct Render: View {
      let delete: () async -> Void
      
      var body: some View {
        AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated, action: delete) {
          Label("DELETE", systemImage: "trash")
        }
        .tint(.red)
        .accessibilityIdentifier("delete-item")
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ItemDeleteMenu_Previews: PreviewProvider {
  static var previews: some View {
    List {
      Item.DeleteMenu.Render {}
    }
  }
}
#endif
