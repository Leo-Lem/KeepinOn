//	Created by Leopold Lemmermann on 29.10.22.

import SwiftUI

extension Page {
  @ViewBuilder func view() -> some View {
    switch self {
    case .home: HomeView()
    case .open: ProjectsView(closed: false)
    case .closed: ProjectsView(closed: true)
    case .awards: AwardsView()
    case .community: CommunityView()
    }
  }
}
