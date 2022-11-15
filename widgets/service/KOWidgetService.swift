//	Created by Leopold Lemmermann on 09.11.22.

import Combine
import Concurrency
import Errors
import UIKit
import WidgetKit

class KOWidgetService: WidgetService {
  private let tasks = Tasks()

  init() {
    tasks.add(updateWidgetsOnResignActive())
  }

  func provide(_ items: [Item.WithProject]) {
    printError {
      try JSONEncoder()
        .encode(items)
        .write(to: config.containerURL.appending(path: Self.filename))
    }
  }

  func receive() -> [Item.WithProject] {
    printError {
      try JSONDecoder()
        .decode(
          [Item.WithProject].self,
          from: try Data(contentsOf: config.containerURL.appending(path: Self.filename))
        )
    } ?? []
  }
}

private extension KOWidgetService {
  static let filename = "WidgetData.json"

  func updateWidgetsOnResignActive() -> Task<Void, Never> {
    NotificationCenter.default
      .publisher(for: UIApplication.willResignActiveNotification)
      .getTask { _ in WidgetCenter.shared.reloadAllTimelines() }
  }
}
