//	Created by Leopold Lemmermann on 05.12.22.

import SwiftUI

extension EntryView {
  var compact: some View {
    TabView(selection: $mainState.presentation.page) {
      HomeView()
        .embedInNavigationStack()
        .tag(Page.home)
        .tabItem { Label("HOME_TAB", systemImage: "house") }
        .accessibilityIdentifier("select-home-page")

      ProjectsView(closed: false)
        .embedInNavigationStack()
        .tag(Page.open)
        .tabItem { Label("OPEN_TAB", systemImage: "list.bullet") }
        .accessibilityIdentifier("select-open-page")

      ProjectsView(closed: true)
        .embedInNavigationStack()
        .tag(Page.closed)
        .tabItem { Label("CLOSED_TAB", systemImage: "checkmark") }
        .accessibilityIdentifier("select-closed-page")

      AwardsView()
        .embedInNavigationStack()
        .tag(Page.awards)
        .tabItem { Label("AWARDS_TAB", systemImage: "rosette") }
        .accessibilityIdentifier("select-awards-page")

      CommunityView()
        .embedInNavigationStack()
        .tag(Page.community)
        .tabItem { Label("COMMUNITY_TAB", systemImage: "person.3") }
        .accessibilityIdentifier("select-community-page")
    }
    .sheet(item: $mainState.presentation.detail) { detailPage in
      detailPage.presentation
        .alert($mainState.presentation.alert, mainState: mainState)
    }
    .alert($mainState.presentation.alert, mainState: mainState)
  }
}
