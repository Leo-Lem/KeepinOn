//	Created by Leopold Lemmermann on 05.12.22.

import SwiftUI

enum Page: String, Hashable, CaseIterable, Identifiable {
  case home, open, closed, awards, community
  
  var id: String { rawValue }
  
  var view: some View { createView() }
  @ViewBuilder func createView() -> some View {
    switch self {
    case .home: HomeView()
    case .open: ProjectsView(closed: false)
    case .closed: ProjectsView(closed: true)
    case .awards: AwardsView()
    case .community: CommunityView()
    }
  }
  
  @ViewBuilder func label() -> some View {
    switch self {
    case .home: Label("HOME_TAB", systemImage: "house").accessibilityIdentifier("select-home-page")
    case .open: Label("OPEN_TAB", systemImage: "list.bullet").accessibilityIdentifier("select-open-page")
    case .closed: Label("CLOSED_TAB", systemImage: "checkmark").accessibilityIdentifier("select-closed-page")
    case .awards: Label("AWARDS_TAB", systemImage: "rosette").accessibilityIdentifier("select-awards-page")
    case .community: Label("COMMUNITY_TAB", systemImage: "person.3").accessibilityIdentifier("select-community-page")
    }
  }
}
