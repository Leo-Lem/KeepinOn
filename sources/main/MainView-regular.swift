//	Created by Leopold Lemmermann on 05.12.22.

import SwiftUI

extension MainView {
  @ViewBuilder func regularLayout(page: Binding<MainPage>, detail: Binding<MainDetail>) -> some View {
    NavigationSplitView(columnVisibility: $navCols) {
      List(selection: Binding { page.wrappedValue } set: { page.wrappedValue = $0 ?? .home }) {
        ForEach([MainPage.home, .open, .closed, .feed, .profile]) { page in
          NavigationLink(value: page, label: page.label)
        }
      }
      .navigationTitle(Config.appname)
      .toolbar(content: testDataMenu)
      .listStyle(.sidebar)

      Spacer()

      AccountMenu()
        .buttonStyle(.borderless)
        .padding()
    } content: {
      page.wrappedValue.view(size: size)
        .navigationTitle(page.wrappedValue.title)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(page.wrappedValue.title)
    } detail: {
      if page.wrappedValue == .home {
        Item.FeaturedView()
      } else {
        detail.wrappedValue.view(size: size)
      }
    }
  }
}
