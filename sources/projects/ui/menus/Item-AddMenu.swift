//	Created by Leopold Lemmermann on 07.12.22.

import ComposableArchitecture
import InAppPurchaseUI
import LeosMisc
import SwiftUI

extension Item {
  struct AddMenu: View {
    var projectID: Project.ID
    
    var body: some View {
      WithViewStore(store) { $0.itemLimitIsReached(projectID) } send: { (action: ViewAction) in
        switch action {
        case .load:
          return .privateDatabase(.projects(.loadWith(id: projectID)))
        case let .add(item):
          return .privateDatabase(.items(.add(item)))
        case let .addToProject(item):
          return .privateDatabase(.projects(.modifyWith(id: projectID) { $0.items.append(item.id) }))
         }
        } content: { store in
          Render(limitIsReached: store.state) {
            let item = Item(project: projectID)
            await store.send(.add(item)).finish()
            await store.send(.addToProject(item)).finish()
          }
          .task { await store.send(.load).finish() }
        }
    }

    @EnvironmentObject private var store: StoreOf<MainReducer>
    enum ViewAction { case load, add(Item), addToProject(Item) }

    struct Render: View {
      let limitIsReached: Bool
      let add: () async -> Void

      var body: some View {
        AsyncButton(indicatorStyle: .edge(.trailing), taskPriority: .userInitiated) {
          guard !limitIsReached else { return }
          await add()
        } label: {
          Label("ADD_ITEM", systemImage: "plus.circle")
        }
        .accessibilityIdentifier("add-item")
        .popover(isPresented: $isPurchasing) { InAppPurchaseView(id: .fullVersion, service: iapService) }
      }

      @State private var isPurchasing = false
      @Dependency(\.inAppPurchaseService) private var iapService
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ItemAddMenu_Previews: PreviewProvider {
  static var previews: some View {
    List {
      Item.AddMenu.Render(limitIsReached: false) {}
      Item.AddMenu.Render(limitIsReached: true) {}.previewDisplayName("Limit reached")
    }
  }
}
#endif
