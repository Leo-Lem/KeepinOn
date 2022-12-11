//	Created by Leopold Lemmermann on 05.12.22.

import SwiftUI

extension EntryView {
  var regular: some View {
    NavigationSplitView {
      List(selection: Binding { mainState.presentation.page } set: { newValue in
        mainState.presentation.page = newValue ?? .home
      }) {
        NavigationLink(value: Page.home, label: Label("HOME_TAB", systemImage: "house").create)
          .accessibilityIdentifier("select-home-page")
        
        NavigationLink(value: Page.open, label: Label("OPEN_TAB", systemImage: "list.bullet").create)
          .accessibilityIdentifier("select-open-page")
        
        NavigationLink(value: Page.closed, label: Label("CLOSED_TAB", systemImage: "checkmark").create)
          .accessibilityIdentifier("select-closed-page")
        
        NavigationLink(value: Page.awards, label: Label("AWARDS_TAB", systemImage: "rosette").create)
          .accessibilityIdentifier("select-awards-page")
        
        NavigationLink(value: Page.community, label: Label("COMMUNITY_TAB", systemImage: "person.3").create)
          .accessibilityIdentifier("select-community-page")
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
        Group {
          switch mainState.presentation.page {
          case .home: HomeView()
          case .open: ProjectsView(closed: false)
          case .closed: ProjectsView(closed: true)
          case .awards: AwardsView()
          case .community: CommunityView()
          }
        }
        .navigationDestination(item: $mainState.presentation.detail, destination: \.presentation)
      }
      .alert($mainState.presentation.alert, mainState: mainState)
    }
  }
}
