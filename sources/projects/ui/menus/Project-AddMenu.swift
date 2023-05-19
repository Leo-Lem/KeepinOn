//	Created by Leopold Lemmermann on 07.12.22.

import ComposableArchitecture
import InAppPurchaseUI
import LeosMisc
import SwiftUI

extension Project {
  struct AddMenu: View {
    var body: some View {
      WithViewStore(store, observe: \.projectLimitIsReached) { (_: Void) in
        .privateDatabase(.projects(.add(Project())))
      } content: { store in
        Render(limitIsReached: store.state) { await store.send(()).finish() }
      }
    }

    @EnvironmentObject private var store: StoreOf<MainReducer>

    struct Render: View {
      let limitIsReached: Bool
      let add: () async -> Void

      var body: some View {
        AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
          guard !limitIsReached else { return isPurchasing = true }
          await add()
        } label: {
          Label("ADD_PROJECT", systemImage: "rectangle.stack.badge.plus.fill")
        }
        .accessibilityIdentifier("add-project")
        .popover(isPresented: $isPurchasing) { InAppPurchaseView(id: .fullVersion, service: iapService) }
      }

      @State private var isPurchasing = false
      @Dependency(\.inAppPurchaseService) private var iapService
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ProjectAddButton_Previews: PreviewProvider {
  static var previews: some View {
    List {
      Project.AddMenu.Render(limitIsReached: false) {}
      Project.AddMenu.Render(limitIsReached: true) {}
        .previewDisplayName("Limit reached")
    }
  }
}
#endif
