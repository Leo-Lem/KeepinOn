//	Created by Leopold Lemmermann on 29.10.22.

import Combine

protocol RoutingService {
  var didChange: PassthroughSubject<RoutingChange, Never> { get }

  var page: Page { get }
  var sheet: Sheet? { get }

  func route(to view: Route)
}

// MARK: - (CONVENIENCE)

extension RoutingService {
  func route<T>(to routeType: T) {
    if let route = Route(routeType) {
      self.route(to: route)
    }
  }

  func dismiss(_ route: Route? = nil) {
    switch route {
    case .sheet:
      self.route(to: .sheet(nil))
    default: break
    }
  }

  func routeAndWaitForReturn(to view: Route) async {
    route(to: view)

    switch view {
    case .sheet:
      while sheet != nil {}
    default: return
    }
  }
}
