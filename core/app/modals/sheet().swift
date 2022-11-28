//	Created by Leopold Lemmermann on 29.10.22.

import LeosMisc
import SwiftUI

enum Sheet: Hashable, Codable, Identifiable {
  case editProject(Project),
       editItem(Item),
       sharedProject(SharedProject),
       project(Project),
       item(Item)

  var id: String {
    switch self {
    case let .editProject(project):
      return "editProject-\(project.id)"
    case let .editItem(item):
      return "editItem-\(item.id)"
    case let .sharedProject(shared):
      return "shared project-\(shared.id)"
    case let .project(withItems):
      return "project-\(withItems.id)"
    case let .item(item):
      return "item-\(item.id)"
    }
  }
}

extension View {
  func sheet(_ sheet: Binding<Sheet?>, alert: Binding<Alert?>) -> some View {
    self.sheet(item: sheet) {
      $0.view()
        .alert(alert)
    }
  }
}

extension Sheet {
  @ViewBuilder func view() -> some View {
    switch self {
    case let .editProject(project):
      project.editingView()
    case let .editItem(item):
      item.editingView()
    case let .sharedProject(shared):
      shared.detailView()
    case let .project(project):
      project.detailView()
    case let .item(item):
      item.detailView()
    }
  }
}
