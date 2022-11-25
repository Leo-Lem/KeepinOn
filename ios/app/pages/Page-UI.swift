//	Created by Leopold Lemmermann on 22.11.22.

extension Page {
  var label: String {
    switch self {
    case .home: return "HOME_TITLE"
    case .open: return "OPEN_TITLE"
    case .closed: return "CLOSED_TITLE"
    case .awards: return "AWARDS_TITLE"
    case .community: return "COMMUNITY_TITLE"
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
}
