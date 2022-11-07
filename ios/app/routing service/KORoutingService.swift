//	Created by Leopold Lemmermann on 29.10.22.

import Combine
import UIKit

final class KORoutingService: RoutingService {
  let didChange = PassthroughSubject<RoutingChange, Never>()

  private(set) var page: Page = .home
  private(set) var sheet: Sheet?

  private let keyValueService: KeyValueService
  private let tasks = Tasks()

  init(keyValueService: KeyValueService) {
    self.keyValueService = keyValueService

    printError {
      if let page: Page = try keyValueService.fetchObject(for: Self.key.page) {
        self.page = page
        didChange.send(.routedTo(.page(page)))
      }

      if let sheet: Sheet = try keyValueService.fetchObject(for: Self.key.sheet) {
        self.sheet = sheet
        didChange.send(.routedTo(.sheet(sheet)))
      }
    }

    tasks.add(saveOnResignActive())
  }

  func route(to route: Route) {
    switch route {
    case let .page(page):
      self.page = page
      didChange.send(.routedTo(.page(page)))
    case let .sheet(sheet):
      self.sheet = sheet
      didChange.send(.routedTo(.sheet(sheet)))
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
