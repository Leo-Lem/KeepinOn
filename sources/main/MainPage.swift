//	Created by Leopold Lemmermann on 05.12.22.

import SwiftUI

enum MainPage: String, Hashable, Identifiable {
  case home, open, closed, feed, profile
  
  var id: String { rawValue }
  
  func label() -> some View {
    Label(LocalizedStringKey(String("\(rawValue.uppercased())_TAB")), systemImage: systemImage)
      .accessibilityIdentifier("select-\(rawValue)-page")
  }
  
  var title: LocalizedStringKey {
    LocalizedStringKey(String("\(rawValue.uppercased())_TITLE"))
  }
  
  private var systemImage: String {
    switch self {
    case .home: return "house"
    case .open: return "list.bullet"
    case .closed: return "checkmark"
    case .feed: return "rectangle.3.offgrid"
    case .profile: return "person"
    }
  }
}

extension MainPage {
  @ViewBuilder func view(size: SizeClass) -> some View {
    switch self {
    case .home:
      if size == .compact {
        VStack {
          Project.FeaturedView()
          Item.FeaturedView()
        }
      } else { Project.FeaturedView() }
    case .open: Project.ListView(closed: false)
    case .closed: Project.ListView(closed: true)
    case .feed: FeedView()
    case .profile: ProfileView()
    }
  }
}
