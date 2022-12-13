//	Created by Leopold Lemmermann on 05.12.22.

import LeosMisc
import SwiftUI

extension EntryView {
  var compact: some View {
    TabView(selection: $page) {
      ForEach(Page.allCases) { page in
        page.view
          .toolbar { ToolbarItem(placement: .cancellationAction) { AccountMenu().labelStyle(.titleAndIcon) } }
          .embedInNavigationStack()
          .tag(page)
          .tabItem(page.label)
      }
    }
    .sheet(item: $detail, content: \.view)
  }
}
