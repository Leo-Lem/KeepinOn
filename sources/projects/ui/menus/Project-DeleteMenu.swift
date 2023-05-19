//	Created by Leopold Lemmermann on 07.12.22.

import ComposableArchitecture
import InAppPurchaseUI
import LeosMisc
import SwiftUI

extension Project {
  struct DeleteMenu: View {
    let id: Project.ID

    var body: some View {
      WithConvertibleViewStore(
        with: id, from: \.privateDatabase.projects, loadWith: .init { .privateDatabase(.projects($0)) }
      ) { convertible in
        Unwrap(convertible) { (project: Project) in
          WithPresentationViewStore { _, detail in
            WithViewStore(store) { $0 } send: { (action: ViewAction) in
              switch action {
              case let .deleteProject(id): return .privateDatabase(.projects(.deleteWith(id: id)))
              case let .deleteItem(id): return .privateDatabase(.items(.deleteWith(id: id)))
              }
            } content: { vm in
              Render {
                // TODO: delete shared
                for itemID in project.items { await vm.send(.deleteItem(id: itemID), animation: .default).finish() }
                await vm.send(.deleteProject(id: id), animation: .default).finish()
                detail.wrappedValue = .empty
              }
            }
          }
        }
      }
    }

    @EnvironmentObject private var store: StoreOf<MainReducer>
    enum ViewAction { case deleteProject(id: Project.ID), deleteItem(id: Item.ID) }

    struct Render: View {
      let delete: () async -> Void

      var body: some View {
        Button { isDeleting = true } label: { Label("DELETE_PROJECT", systemImage: "xmark.octagon") }
          .tint(.red)
          .alert("DELETE_PROJECT_ALERT_TITLE", isPresented: $isDeleting) {
            Button("DELETE", role: .destructive) {
              Task(priority: .userInitiated) {
                await delete()
                isDeleting = false
              }
            }
          } message: { Text("DELETE_PROJECT_ALERT_MESSAGE") }
          .accessibilityLabel("delete-project")
      }

      @State private var isDeleting = false
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ProjectDeleteMenu_Previews: PreviewProvider {
  static var previews: some View {
    Project.DeleteMenu.Render {}
  }
}
#endif
