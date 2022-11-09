//	Created by Leopold Lemmermann on 29.10.22.

import Combine
import UIKit

final class KORoutingService: RoutingService {
  let didRouteTo = PassthroughSubject<Route, Never>()

  private(set) var page: Page = .home
  private(set) var sheet: Sheet?
  private(set) var alert: Alert?
  private(set) var banner: Banner?

  private let keyValueService = UDService()
  private let tasks = Tasks()

  init() {
    printError {
      if let page: Page = try keyValueService.fetchObject(for: Self.key.page) {
        self.page = page
        didRouteTo.send(.page(page))
      }

      if let sheet: Sheet = try keyValueService.fetchObject(for: Self.key.sheet) {
        self.sheet = sheet
        didRouteTo.send(.sheet(sheet))
      }
    }

    tasks.add(saveOnResignActive())
  }

  func route(to route: Route) {
    switch route {
    case let .page(page):
      self.page = page
      didRouteTo.send(.page(page))
    case let .sheet(sheet):
      self.sheet = sheet
      didRouteTo.send(.sheet(sheet))
    case let .alert(alert):
      self.alert = alert
      didRouteTo.send(.alert(alert))
    case let .banner(banner):
      self.banner = banner
      didRouteTo.send(.banner(banner))
    }
  }
}

private extension KORoutingService {
  static let key = (page: "route.page", sheet: "route.sheet")

  func saveOnResignActive() -> Task<Void, Never> {
    NotificationCenter.default
      .publisher(for: UIApplication.willResignActiveNotification)
      .getTask { [weak self] _ in
        printError {
          try self?.keyValueService.insert(object: self?.page, for: Self.key.page)
          
          try self?.keyValueService.delete(for: Self.key.sheet)
          if let sheet = self?.sheet {
            try self?.keyValueService.insert(object: sheet, for: Self.key.sheet)
          }
        }
      }
  }
}
