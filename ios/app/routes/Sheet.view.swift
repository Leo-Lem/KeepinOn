//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

extension View {
  func sheet(
    _ sheet: Binding<Sheet?>,
    appState: AppState
  ) -> some View {
    let binding = Binding(optional: sheet)
    return self.sheet(binding) {
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
      default: EmptyView()
      }
    }
    .environment(\.dismiss) {
      appState.routingService.dismiss(.sheet())
    }
  }
}
