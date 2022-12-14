// Created by Leopold Lemmermann on 18.12.22.

enum MainDetail: Hashable {
  case project(Project)
  case editProject(Project)
  case item(Item)
  case editItem(Item)
  case sharedProject(SharedProject)
  case user(User)
  case customize(User)
  case awards(id: User.ID)
  case friends(id: User.ID)
  case projects(id: User.ID)
  case comments(id: User.ID)
  case empty
}

extension MainDetail: Identifiable {
  var id: String {
    switch self {
    case let .project(project): return "project-\(project.id)"
    case let .editProject(project): return "editProject-\(project.id)"
    case let .item(item): return "item-\(item.id)"
    case let .editItem(item): return "editItem-\(item.id)"
    case let .sharedProject(shared): return "sharedProject-\(shared.id)"
    case let .user(user): return "user-\(user.id)"
    case let .customize(user): return "customize-\(user.id)"
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
    case let .project(project): project.detailView()
    case let .editProject(project): project.editingView()
    case let .item(item): item.detailView()
    case let .editItem(item): item.editingView()
    case let .sharedProject(project): project.detailView()
    case let .user(user): user.detailView()
    case let .customize(user): User.CustomizationView(user)
    case let .awards(id): User.AwardsView()
    case let .friends(id): User.FriendsView(currentUserID: id)
    case let .projects(id): User.SharedProjectsView(currentUserID: id)
    case let .comments(id): User.CommentsView(currentUserID: id)
    default: if size == .regular { Text("EMPTY_TAB_PLACEHOLDER") } else { EmptyView() }
    }
  }
}
