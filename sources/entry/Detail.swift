// Created by Leopold Lemmermann on 08.12.22.

import SwiftUI

enum Detail: Hashable, Codable, Identifiable {
  case editProject(Project),
       editItem(Item),
       sharedProject(SharedProject),
       editUser(User),
       project(Project),
       item(Item)

  var id: String {
    switch self {
    case let .editProject(project): return "editProject-\(project.id)"
    case let .editItem(item): return "editItem-\(item.id)"
    case let .sharedProject(shared): return "shared project-\(shared.id)"
    case let .editUser(user): return "user-\(user.id)"
    case let .project(withItems): return "project-\(withItems.id)"
    case let .item(item): return "item-\(item.id)"
    }
  }
  
  var view: some View { createView() }
  @ViewBuilder func createView() -> some View {
    switch self {
    case let .editProject(project): project.editingView()
    case let .editItem(item): item.editingView()
    case let .sharedProject(shared): shared.detailView()
    case let .editUser(user): user.editingView()
    case let .project(project): project.detailView()
    case let .item(item): item.detailView()
    }
  }
}
