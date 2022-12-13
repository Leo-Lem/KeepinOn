//	Created by Leopold Lemmermann on 05.12.22.

import SwiftUI

extension EntryView {
  var regular: some View {
    NavigationSplitView {
      List(selection: Binding { page } set: { newValue in page = newValue ?? .home }) {
        ForEach(Page.allCases) { page in
          NavigationLink(value: page, label: page.label)
        }
      }
      .navigationTitle("KeepinOn")
      .listStyle(.sidebar)

      Spacer()
      Divider()
        .padding(-10)

      AccountMenu()
        .padding(10)
        .frame(maxWidth: .infinity)
    } detail: {
      NavigationStack {
        page.view
          .navigationDestination(item: $detail, destination: \.view)
      }
    }
  }
}
