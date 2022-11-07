//	Created by Leopold Lemmermann on 29.10.22.

import SwiftUI

extension Page {
  static var tabs: [Page] = [.home, .open, .closed, .awards, .community]

  @ViewBuilder func getView(appState: AppState) -> some View {
    switch self {
    case .home: HomeView(appState: appState)
    case .open: ProjectsView(closed: false, appState: appState)
    case .closed: ProjectsView(closed: true, appState: appState)
    case .awards: AwardsView(appState: appState)
    case .community: CommunityView(appState: appState)
    }
  }

  var icon: String {
    switch self {
    case .home: return "house"
    case .open: return "list.bullet"
    case .closed: return "checkmark"
    case .awards: return "rosette"
    case .community: return "person.3"
    }
  }

  var label: LocalizedStringKey {
    switch self {
    case .home: return "HOME_TITLE"
    case .open: return "OPEN_TITLE"
    case .closed: return "CLOSED_TITLE"
    case .awards: return "AWARDS_TITLE"
    case .community: return "COMMUNITY_TITLE"
    }
  }
}
