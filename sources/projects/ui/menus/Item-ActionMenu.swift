//	Created by Leopold Lemmermann on 07.12.22.

import ComposableArchitecture
import CoreDataService
import CoreHapticsService
import Errors
import LeosMisc
import SwiftUI
import InAppPurchaseUI

extension Item {
  struct ActionMenu: View {
    static func add(projectID: Project.ID) -> Self { Self(.add(projectID: projectID)) }
    static func toggle(_ item: Item) -> Self { Self(.toggle(item)) }
    static func delete(_ item: Item) -> Self { Self(.delete(item)) }
    
    var body: some View {
      WithViewStore<ViewState, ViewAction, _>(store) { state in
        ViewState(itemsLimitIsReached: state.itemLimitIsReached(action.projectID))
      } send: { action in
          .privateDatabase({
            switch action {
            case .load:
              return .projects(.loadWith(id: self.action.projectID))
            case let .add(item):
              return .items(.add(item))
            case let .toggle(id):
              return .items(.modifyWith(id: id) { $0.isDone.toggle() })
            case let .delete(id):
              return .items(.deleteWith(id: id))
            case let .addToProject(item):
              return .projects(.modifyWith(id: item.project) { $0.items.append(item.id) })
            case let .deleteFromProject(item):
              return .projects(.modifyWith(id: item.project) { $0.items.removeAll { $0 == item.id } })
            }
          }())
      } content: { vm in
        // TODO: add awards
        switch action {
        case let .add(projectID):
          Item.AddButton(limitIsReached: vm.itemsLimitIsReached) {
            let item = Item(project: projectID)
            await vm.send(.add(item), animation: .default).finish()
            await vm.send(.addToProject(item), animation: .default).finish()
          }
          .task { await vm.send(.load).finish() }
          
        case let .toggle(item):
          Item.ToggleButton(isDone: item.isDone) { await vm.send(.toggle(id: item.id)).finish() }
          
        case let .delete(item):
          Item.DeleteButton {
            await vm.send(.delete(id: item.id), animation: .default).finish()
            await vm.send(.deleteFromProject(item), animation: .default).finish()
          }
        }
      }
    }
    
    @EnvironmentObject private var store: StoreOf<MainReducer>
    
    private let action: MenuAction
    private init(_ action: MenuAction) { self.action = action }
    
    private enum MenuAction: Equatable {
      case add(projectID: Project.ID)
      case toggle(Item)
      case delete(Item)
      
      var projectID: Project.ID {
        switch self {
        case let .add(projectID): return projectID
        case let .toggle(item), let .delete(item): return item.project
        }
      }
    }
    
    struct ViewState: Equatable {
      var itemsLimitIsReached: Bool
    }

    enum ViewAction {
      case load
      case add(Item)
      case addToProject(Item)
      case toggle(id: Item.ID)
      case delete(id: Item.ID)
      case deleteFromProject(Item)
    }
  }
  
  struct AddButton: View {
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
  
  struct ToggleButton: View {
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
  
  struct DeleteButton: View {
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

// MARK: - (PREVIEWS)

#if DEBUG
struct ItemActionMenu_Previews: PreviewProvider {
  static var previews: some View {
    List {
      Item.ActionMenu.add(projectID: Project.example.id)
      Item.ActionMenu.toggle(.example)
      Item.ActionMenu.delete(.example)
    }
  }
}
#endif
