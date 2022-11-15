//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

extension View {
  func sheet(
    _ sheet: Binding<Sheet?>,
    appState: AppState
  ) -> some View {
    self.sheet(Binding(optional: sheet)) {
      switch sheet.wrappedValue {
      case let .editProject(project):
        EditProjectView(project, appState: appState)
      case let .editItem(item):
        EditItemView(item, appState: appState)
      case let .sharedProject(project):
        SharedProjectView(project, appState: appState)
      case .purchase:
        PurchasingView(appState: appState)
      case .account:
        AccountView(appState: appState)
      case let .project(projectWithItems):
        Project.Details(projectWithItems)
      case let .item(item, projectWithItems):
        Item.Details(item, projectWithItems: projectWithItems)
      default: EmptyView()
      }
    }
    .environment(\.dismiss) {
      appState.routingService.dismiss(.sheet())
    }
  }
}
