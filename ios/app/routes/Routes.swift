//	Created by Leopold Lemmermann on 29.10.22.

import Foundation

enum Route {
  case page(Page),
       sheet(Sheet? = nil)

  init?<T>(_ routeType: T) {
    switch routeType {
    case let page as Page:
      self = .page(page)
    case let sheet as Sheet?:
      self = .sheet(sheet)
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
       account
}
