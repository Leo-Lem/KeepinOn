// Created by Leopold Lemmermann on 11.12.22.

import SwiftUI
import LeosMisc

extension View {
  func platformAdjustedMenu<Actions: View>(
    primaryAction: @escaping () -> Void,
    @ViewBuilder actions: @escaping () -> Actions
  ) -> some View {
    #if os(iOS)
    Menu(content: actions, label: self.create, primaryAction: primaryAction)
    #elseif os(macOS)
    Button(action: primaryAction, label: self.create)
      .contextMenu(menuItems: actions)
    #endif
  }
}
