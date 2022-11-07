//	Created by Leopold Lemmermann on 29.10.22.

import Foundation

enum Route {
  case page(Page),
       sheet(Sheet? = nil),
       alert(Alert? = nil),
       banner(Banner? = nil)

  init?<T>(_ routeType: T) {
    switch routeType {
    case let page as Page:
      self = .page(page)
    case let sheet as Sheet?:
      self = .sheet(sheet)
    case let alert as Alert?:
      self = .alert(alert)
    case let banner as Banner?:
      self = .banner(banner)
    default:
      return nil
    }
  }
}

enum Page: Hashable, Codable {
  case home,
       closed,
       open,
       awards,
       community
}

enum Sheet: Hashable, Codable {
  case editProject(Project),
       editItem(Item),
       sharedProject(Project.Shared),
       purchase,
       account,
       project(Project),
       item(Item)
}

enum Alert: Equatable {
  case error(String),
       award(Award, unlocked: Bool),
       delete(
         project: Project,
         fulfill: (Project) -> Void
       )

  static func == (lhs: Alert, rhs: Alert) -> Bool {
    switch (lhs, rhs) {
    case let (.error(error1), .error(error2)):
      return error1 == error2
    case let (.award(award1, unlocked1), .award(award2, unlocked2)):
      return award1 == award2 && unlocked1 == unlocked2
    case let (.delete(project1, _), .delete(project2, _)):
      return project1 == project2
    default:
      return false
    }
  }
}

enum Banner: Hashable, Codable {
  case awardEarned(Award)
}
