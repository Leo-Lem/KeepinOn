// Created by Leopold Lemmermann on 18.12.22.

enum MainDetail: Hashable {
  case project(id: Project.ID)
  case editProject(id: Project.ID)
  case item(id: Item.ID)
  case editItem(id: Item.ID)
  case sharedProject(id: SharedProject.ID)
  case user(id: User.ID)
  case customize(id: User.ID)
  case awards(id: User.ID)
  case friends(id: User.ID)
  case projects(id: User.ID)
  case comments(id: User.ID)
  case empty
}

extension MainDetail: Identifiable {
  var id: String {
    switch self {
    case let .project(id): return "project-\(id)"
    case let .editProject(id): return "editProject-\(id)"
    case let .item(id): return "item-\(id)"
    case let .editItem(id): return "editItem-\(id)"
    case let .sharedProject(id): return "sharedProject-\(id)"
    case let .user(id): return "user-\(id)"
    case let .customize(id): return "customize-\(id)"
    case let .awards(id): return "awards-\(id)"
    case let .friends(id): return "friends-\(id)"
    case let .projects(id): return "projects-\(id)"
    case let .comments(id): return "comments-\(id)"
    case .empty: return ""
    }
  }
}

import SwiftUI

extension MainDetail {
  // swiftlint:disable:next cyclomatic_complexity
  @ViewBuilder func view(size: SizeClass) -> some View {
    switch self {
    case let .project(id): Project.DetailView(id: id)
    case let .editProject(id): Project.EditingView(id: id)
    case let .item(id): Item.DetailView(id: id)
    case let .editItem(id): Item.EditingView(id: id)
    case let .sharedProject(id): SharedProject.DetailView(id: id)
    case let .user(id): User.DetailView(id: id)
    case let .customize(id): User.CustomizationView(id: id)
    case let .awards(id): User.AwardsView()
    case let .friends(id): User.FriendsView(currentUserID: id)
    case let .projects(id): User.SharedProjectsView(currentUserID: id)
    case let .comments(id): User.CommentsView(currentUserID: id)
    default: if size == .regular { Text("EMPTY_TAB_PLACEHOLDER") } else { EmptyView() }
    }
  }
}
