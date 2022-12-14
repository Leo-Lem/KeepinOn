//	Created by Leopold Lemmermann on 05.12.22.

import SwiftUI

extension MainView {
  @ViewBuilder func regularLayout() -> some View {
    NavigationSplitView(columnVisibility: $navCols) {
      List(selection: Binding { page } set: { newValue in page = newValue ?? .home }) {
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
      page.view(size: size)
        .navigationTitle(page.title)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(page.title)
    } detail: {
      if page == .home {
        Item.FeaturedView()
      } else {
        detail.view(size: size)
      }
    }
  }
}
