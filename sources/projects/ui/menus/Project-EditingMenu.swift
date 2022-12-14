// Created by Leopold Lemmermann on 20.12.22.

import Colors
import ComposableArchitecture
import LeosMisc
import SwiftUI

extension Project {
  @ViewBuilder func editingMenu(_ kind: EditingMenu.Kind) -> some View { EditingMenu(self, kind: kind) }
  
  struct EditingMenu: View {
    let project: Project
    let kind: Kind
    
    var body: some View {
      WithViewStore<ViewState, ViewAction, _>(store) { state in
        ViewState(
          notificationsAreAuthorized: state.notifications.remindersAreAuthorized ?? false,
          currentUserID: state.account.id,
          items: state.privateDatabase.items.convertibles(matching: .init(\.project, project.id)),
          isPublished: state.publicDatabase.projects.convertible(with: project.id) != nil,
          hasiCloud: state.account.canPublish
        )
      } send: { action in
        switch action {
        case let .setTitle(title):
          return .privateDatabase(.projects(.modifyWith(id: project.id) { $0.title = title }))
        case let .setDetails(details):
          return .privateDatabase(.projects(.modifyWith(id: project.id) { $0.details = details }))
        case let .setColorID(colorID):
          return .privateDatabase(.projects(.modifyWith(id: project.id) { $0.colorID = colorID }))
        case let .setReminder(reminder):
          return .privateDatabase(.projects(.modifyWith(id: project.id) { $0.reminder = reminder }))
        case .authorize:
          return .notifications(.authorizeReminders)
        case .loadIsPublished:
          return .publicDatabase(.projects(.loadWith(id: project.id)))
        case .loadItems:
          return .privateDatabase(.items(.loadFor(query: .init(\.project, project.id))))
        case let .publishProject(id):
          return .publicDatabase(.projects(.add(SharedProject(project, owner: id))))
        case let .publishItem(item):
          return .publicDatabase(.items(.add(SharedItem(item))))
        case .unpublish:
          return .publicDatabase(.projects(.deleteWith(id: project.id)))
        }
      } content: { vm in
        switch kind {
        case .description:
          TextField(project.title ??? String(localized: "PROJECT_NAME_PLACEHOLDER"), text: $newTitle)
            .accessibilityLabel("A11Y_EDIT_PROJECT_NAME")
            .accessibilityIdentifier("edit-project-name")
            .onChange(of: project.title) { if newTitle != $0 { newTitle = "" } }
            .onChange(of: newTitle) { vm.send(.setTitle($0)) }
          
          TextField(project.details ??? String(localized: "PROJECT_DESCRIPTION_PLACEHOLDER"), text: $newDetails)
            .accessibilityLabel("A11Y_EDIT_PROJECT_DESCRIPTION")
            .accessibilityIdentifier("edit-project-description")
            .onChange(of: project.details) { if newDetails != $0 { newDetails = "" } }
            .onChange(of: newDetails) { vm.send(.setDetails($0)) }
          
        case .color:
          ColorID.SelectionMenu($colorID)
            .onChange(of: colorID) { vm.send(.setColorID($0)) }
            .onChange(of: project.colorID) { if colorID != $0 { colorID = $0 } }
            .accessibilityLabel("PROJECT_SELECT_COLOR")
          
        case .reminder:
          Reminder.SelectionMenu($reminder, isAuthorized: vm.notificationsAreAuthorized) {
            await vm.send(.authorize).finish()
          }
          .onChange(of: project.reminder) { reminder = $0 }
          .onChange(of: reminder) { vm.send(.setReminder($0)) }
          
        case .publish:
          Project.PublishingMenu(
            isPublished: vm.isPublished, hasiCloud: vm.hasiCloud, isLoggedIn: vm.currentUserID != nil
          ) {
            if let id = vm.currentUserID {
              for item in vm.items { await vm.send(.publishItem(item)).finish() }
              await vm.send(.publishProject(id)).finish()
            }
          } unpublish: {
            await vm.send(.unpublish).finish()
          }
        }
      }
    }
    
    @State private var newTitle = ""
    @State private var newDetails = ""
    @State private var colorID: ColorID
    @State private var reminder: Reminder
    @EnvironmentObject private var store: StoreOf<MainReducer>
    
    init(_ project: Project, kind: Kind) {
      (self.project, self.kind) = (project, kind)
      (_colorID, _reminder) = (State(initialValue: project.colorID), State(initialValue: project.reminder))
    }
    
    enum Kind: Hashable {
      case description
      case color
      case reminder
      case publish
    }
    
    struct ViewState: Equatable {
      var notificationsAreAuthorized: Bool
      var currentUserID: User.ID?, items: [Item], isPublished: Bool, hasiCloud: Bool
    }

    enum ViewAction {
      case setTitle(String), setDetails(String)
      case setColorID(ColorID)
      case setReminder(Reminder), authorize
      case loadIsPublished, loadItems, publishProject(User.ID), publishItem(Item), unpublish
    }
  }
}

// private extension Project.PublishingMenu {
//  @MainActor func publish() async throws {
//    guard let userID = accountController.id else { return }
//
//    let items = try await projectsController.databaseService.fetchAndCollect(Query(\.project, project.id))
//      .map(SharedItem.init)
//    try await accountController.databaseService.insert(items).collect()
//
//    try await accountController.databaseService.insert(SharedProject(project, owner: userID))
//
//    hapticsService?.play(.taDa)
//  }
