//	Created by Leopold Lemmermann on 06.11.22.

import SwiftUI

extension View {
  func alert(
    _ alert: Binding<Alert?>,
    routingService: RoutingService
  ) -> some View {
    let binding = Binding(optional: alert)

    return self.alert(binding) {
      switch alert.wrappedValue {
      case let .error(error):
        Text("ERROR_TITLE").bold()
        Text(error)
          .preferred(style: OutlineStyle(color: .red))
      case let .award(award, unlocked):
        Text(unlocked ? "UNLOCKED \(award.name)" : "LOCKED").bold()
        Text(award.description)
          .preferred(style: OutlineStyle(color: award.color))
      case .delete:
        Text("DELETE_PROJECT_ALERT_TITLE").bold()
        Text("DELETE_PROJECT_ALERT_MESSAGE")
          .preferred(style: OutlineStyle(color: .red))
      default: EmptyView()
      }
    } actions: { dismiss in
      switch alert.wrappedValue {
      case let .delete(project, fulfillDelete):
        Button("GENERIC_DELETE", role: .destructive) {
          fulfillDelete(project)
          dismiss()
        }
        Button("GENERIC_CANCEL", action: dismiss)
      case let .award(award, unlocked):
        if award.criterion == .unlock && !unlocked {
          Button(
            action: {
              routingService.route(to: .sheet(.purchase))
              dismiss()
            }, label: { Label("UNLOCK_FULL_VERSION", systemImage: "cart") }
          )
        }
        Button("GENERIC_OK", action: dismiss)
      default:
        Button("GENERIC_OK", action: dismiss)
      }
    }
    .environment(\.dismiss) { routingService.dismiss(.alert()) }
  }
}
