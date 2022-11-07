//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

struct AlertLink<Content: View>: View {
  let alert: Alert,
      label: () -> Content

  @EnvironmentObject var appState: AppState

  var body: some View {
    Button(action: { appState.routingService.route(to: .alert(alert)) }, label: label)
  }

  init(_ alert: Alert, label: @escaping () -> Content) {
    self.alert = alert
    self.label = label
  }

  init(_ title: LocalizedStringKey, _ alert: Alert) where Content == Text {
    self.init(alert) { Text(title) }
  }

  @_disfavoredOverload init<S: StringProtocol>(_ title: S, _ alert: Alert) where Content == Text {
    self.init(alert) { Text(title) }
  }
}
