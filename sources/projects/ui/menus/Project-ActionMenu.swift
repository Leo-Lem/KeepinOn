//	Created by Leopold Lemmermann on 07.12.22.

import ComposableArchitecture
import CoreDataService
import CoreHapticsService
import Errors
import LeosMisc
import SwiftUI
import InAppPurchaseUI

extension Project {
  struct ActionMenu: View {
    static let add = Self(.add)
    static func toggle(_ project: Project, playsHaptic: Bool = false) -> Self {
      Self(.toggle(project, playsHaptic: playsHaptic))
    }
    static func delete(_ project: Project) -> Self { Self(.delete(project)) }
    
    var body: some View {
      WithViewStore<ViewState, ViewAction, _>(store) { state in
        ViewState(projectsLimitIsReached: state.projectLimitIsReached)
      } send: { action in
          .privateDatabase({
            switch action {
            case .load: return .projects(.loadFor(query: Query(\.isClosed, false)))
            case .add: return .projects(.add(Project()))
            case let .toggle(id): return .projects(.modifyWith(id: id) { $0.isClosed.toggle() })
            case let .deleteProject(id): return .projects(.deleteWith(id: id))
            case let .deleteItem(id): return .items(.deleteWith(id: id))
            }
          }())
      } content: { vm in
        switch action {
        case .add:
          Project.AddButton(limitIsReached: vm.projectsLimitIsReached) { await vm.send(.add).finish() }
            .task { await vm.send(.load).finish() }
          
        case let .toggle(project, playsHaptic):
          Project.ToggleButton(
            isClosed: project.isClosed, limitIsReached: vm.projectsLimitIsReached, playsHaptic: playsHaptic
          ) {
            await vm.send(.toggle(id: project.id)).finish()
          }
          
        case let .delete(project):
          Project.DeleteButton(id: project.id) {
            for itemID in project.items { await vm.send(.deleteItem(id: itemID), animation: .default).finish() }
            await vm.send(.deleteProject(id: project.id), animation: .default).finish()
          }
        }
      }
    }
    
    @EnvironmentObject private var store: StoreOf<MainReducer>
    
    private let action: MenuAction
    private init(_ action: MenuAction) { self.action = action }
    
    private enum MenuAction: Equatable {
      case add
      case toggle(Project, playsHaptic: Bool)
      case delete(Project)
    }
    
    struct ViewState: Equatable {
      var projectsLimitIsReached: Bool
    }
    
    enum ViewAction {
      case load
      case add
      case toggle(id: Project.ID)
      case deleteProject(id: Project.ID)
      case deleteItem(id: Item.ID)
    }
  }
  
  struct AddButton: View {
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
  
  struct ToggleButton: View {
    let isClosed: Bool
    let limitIsReached: Bool
    let playsHaptic: Bool
    let toggle: () async -> Void
    
    var body: some View {
      AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
        if isClosed && limitIsReached { return isPurchasing = true }
        
        await toggle()
        present(MainDetail.empty)
        
        if isClosed { present(MainPage.open) } else {
          if playsHaptic { hapticsService?.play(.taDa) }
          present(MainPage.closed)
        }
      } label: {
        isClosed ?
          Label("REOPEN_PROJECT", systemImage: "lock.open") :
          Label("CLOSE_PROJECT", systemImage: "lock")
      }
      .accessibilityLabel("toggle-project")
      .popover(isPresented: $isPurchasing) { InAppPurchaseView(id: .fullVersion, service: iapService) }
    }
    
    @State private var isPurchasing = false
    @State private var hapticsService = CoreHapticsService()
    @Dependency(\.inAppPurchaseService) private var iapService
    @Environment(\.present) private var present
  }
  
  struct DeleteButton: View {
    let id: Project.ID
    let delete: () async -> Void
    
    var body: some View {
      Button { isDeleting = true } label: { Label("DELETE_PROJECT", systemImage: "xmark.octagon") }
        .tint(.red)
        .alert("DELETE_PROJECT_ALERT_TITLE", isPresented: $isDeleting) {
          Button("DELETE", role: .destructive) {
            Task(priority: .userInitiated) {
              // TODO: delete shared
              await delete()
              isDeleting = false
              present(MainDetail.empty)
            }
          }
        } message: { Text("DELETE_PROJECT_ALERT_MESSAGE") }
        .accessibilityLabel("delete-project")
    }
    
    @State private var isDeleting = false
    @Environment(\.present) private var present
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ProjectActionMenu_Previews: PreviewProvider {
  static var previews: some View {
    List {
      Project.ActionMenu.add
      Project.ActionMenu.toggle(.example)
      Project.ActionMenu.delete(.example)
    }
  }
}
#endif
