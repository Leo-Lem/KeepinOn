// Created by Leopold Lemmermann on 20.12.22.

import ComposableArchitecture
import Foundation

extension Store: ObservableObject {}

struct MainReducer: ReducerProtocol {
  struct State: Equatable {
    var account: Account.State
    var privateDatabase: PrivateDatabase.State
    var iap: InAppPurchases.State
    var notifications: PushNotifications.State
    var sorting: Sorting.State
    var navigation: Navigation.State

    init(
      userID: User.ID? = nil,
      projects: [Project] = [], items: [Item] = [],
      sharedProjects: [SharedProject] = [], sharedItems: [SharedItem] = [], comments: [Comment] = [],
      users: [User] = [], friendships: [Friendship] = [],
      hasFullVersion: Bool = false,
      remindersAreAuthorized: Bool? = nil,
      itemSortOrder: Item.SortOrder = .optimized,
      page: MainPage = .home, detail: MainDetail = .empty
    ) {
      privateDatabase = .init(projects: projects, items: items)
      account = .init(id: userID, publicDatabase: .init(
        projects: sharedProjects, items: sharedItems, comments: comments, users: users, friendships: friendships
      ))
      iap = .init(hasFullVersion: hasFullVersion)
      notifications = .init(remindersAreAuthorized: remindersAreAuthorized)
      sorting = .init(itemSortOrder: itemSortOrder)
      navigation = .init(page: page, detail: detail)
    }
  }

  enum Action {
    case account(Account.Action)
    case privateDatabase(PrivateDatabase.Action)
    case iap(InAppPurchases.Action)
    case notifications(PushNotifications.Action)
    case sorting(Sorting.Action)
    case navigation(Navigation.Action)
  }

  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    #if DEBUG
      debugPrint(action)
    #endif

    return CombineReducers {
      Scope(state: \.account, action: /Action.account, Account.init)
      Scope(state: \.privateDatabase, action: /Action.privateDatabase, PrivateDatabase.init)
      Scope(state: \.iap, action: /Action.iap, InAppPurchases.init)
      Scope(state: \.notifications, action: /Action.notifications, PushNotifications.init)
      Scope(state: \.sorting, action: /Action.sorting, Sorting.init)
      Scope(state: \.navigation, action: /Action.navigation, Navigation.init)
    }
    .reduce(into: &state, action: action)
  }
}

extension MainReducer.State {
  var publicDatabase: PublicDatabase.State { account.publicDatabase }
}

extension MainReducer.Action {
  static func publicDatabase(_ action: PublicDatabase.Action) -> Self { .account(.publicDatabase(action)) }
}

import Queries
extension MainReducer.State {
  var projectLimitIsReached: Bool {
    !iap.hasFullVersion &&
      privateDatabase.projects.convertibles(matching: Query(\.isClosed, false)).count >= Config.freeLimits.projects
  }

  func itemLimitIsReached(_ projectID: Project.ID) -> Bool {
    !iap.hasFullVersion &&
      privateDatabase.items.convertibles(matching: Query(\.project, projectID)).count >= Config.freeLimits.items
  }
}
