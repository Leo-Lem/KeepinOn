//	Created by Leopold Lemmermann on 05.12.22.

import LeosMisc
import SwiftUI

extension MainView {
  @ViewBuilder func compactLayout(page: Binding<MainPage>, detail: Binding<MainDetail>) -> some View {
    TabView(selection: page) {
      ForEach([MainPage.feed, .open, .home, .closed, .profile]) { page in
        page.view(size: size)
          .accessibilityElement(children: .contain)
          .accessibilityLabel(page.title)
          .navigationTitle(page.title)
          .toolbar { ToolbarItem(placement: .navigationBarLeading) { AccountMenu().labelStyle(.iconOnly) } }
          .toolbar(content: testDataMenu)
          .embedInNavigationStack()
          .tag(page)
          .tabItem(page.label)
      }
    }
    .sheet(item: Binding {
      detail.wrappedValue == .empty ? nil : detail.wrappedValue
    } set: {
      detail.wrappedValue = $0 ?? .empty
    }) { detail in
      detail.view(size: size)
      #if os(iOS)
      .compactDismissButton()
      #endif
    }
    #if canImport(UIKit)
    .onAppear {
      if size == .compact {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
      }
    }
    #endif
  }
}
