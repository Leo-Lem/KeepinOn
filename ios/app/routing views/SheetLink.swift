//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

struct SheetLink<Content: View>: View {
  let sheet: Sheet,
      label: () -> Content

  @EnvironmentObject var appState: AppState

  var body: some View {
    Button(action: { appState.routingService.route(to: sheet) }, label: label)
  }

  init(_ sheet: Sheet, label: @escaping () -> Content) {
    self.sheet = sheet
    self.label = label
  }

  init(_ title: LocalizedStringKey, _ sheet: Sheet) where Content == Text {
    self.init(sheet) { Text(title) }
  }

  @_disfavoredOverload init<S: StringProtocol>(_ title: S, _ sheet: Sheet) where Content == Text {
    self.init(sheet) { Text(title) }
  }
}
