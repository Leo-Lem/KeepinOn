// Created by Leopold Lemmermann on 20.12.22.

import Colors
import ComposableArchitecture
import LeosMisc
import SwiftUI

extension Item {
  @ViewBuilder func editingMenu(_ kind: EditingMenu.Kind) -> some View { EditingMenu(self, kind: kind) }
  
  struct EditingMenu: View {
    let item: Item
    let kind: Kind
    
    var body: some View {
      WithViewStore<ViewState, ViewAction, _>(store) { state in
        ViewState(isAuthorized: state.notifications.remindersAreAuthorized ?? false)
      } send: { action in
          .privateDatabase({
            switch action {
            case let .setTitle(title): return .items(.modifyWith(id: item.id) { $0.title = title })
            case let .setDetails(details): return .items(.modifyWith(id: item.id) { $0.details = details })
            case let .setPriority(priority): return .items(.modifyWith(id: item.id) { $0.priority = priority })
            case .toggle: return .items(.modifyWith(id: item.id) { $0.isDone.toggle() })
            }
          }())
      } content: { vm in
        switch kind {
        case .description:
          TextField(item.title ??? String(localized: "ITEM_NAME_PLACEHOLDER"), text: $newTitle)
            .accessibilityIdentifier("edit-item-name")
            .onChange(of: item.title) { if newTitle != $0 { newTitle = "" } }
            .onChange(of: newTitle) { vm.send(.setTitle($0)) }

          TextField(item.details ??? String(localized: "ITEM_DESCRIPTION_PLACEHOLDER"), text: $newDetails)
            .accessibilityIdentifier("edit-item-description")
            .onChange(of: item.details) { if newDetails != $0 { newDetails = "" } }
            .onChange(of: newDetails) { vm.send(.setDetails($0)) }
          
        case .priority:
          Picker(
            String(localized: "PRIORITY"), selection: $priority, items: Item.Priority.allCases, id: \.self
          ) { priority in
            Text(priority.titleKey).tag(priority)
          }
          .pickerStyle(.segmented)
          .labelsHidden()
          .onChange(of: item.priority) { if priority != $0 { priority = $0 } }
          .onChange(of: priority) { vm.send(.setPriority($0)) }
          
        case .toggle:
          Toggle("MARK_COMPLETED", isOn: Binding { item.isDone } set: { _ in
            Task(priority: .userInitiated) {
              await vm.send(.toggle).finish()
              present(MainDetail.empty)
            }
          })
        }
      }
    }
    
    @State private var newTitle = ""
    @State private var newDetails = ""
    @State private var priority: Item.Priority
    @Environment(\.present) private var present
    @EnvironmentObject private var store: StoreOf<MainReducer>
    
    init(_ item: Item, kind: Kind) {
      (self.item, self.kind) = (item, kind)
      _priority = State(initialValue: item.priority)
    }
    
    enum Kind: Hashable {
      case description
      case priority
      case toggle
    }
    
    struct ViewState: Equatable { var isAuthorized: Bool }
    enum ViewAction {
      case setTitle(String)
      case setDetails(String)
      case setPriority(Priority)
      case toggle
    }
  }
}
