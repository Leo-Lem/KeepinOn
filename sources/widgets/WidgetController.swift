//	Created by Leopold Lemmermann on 09.11.22.

import Combine
import Concurrency
import Errors
import UIKit
import WidgetKit

class WidgetController {
  private let tasks = Tasks()

  init() {
    tasks["updateWidgetsOnResignActive"] = Task {
      for await _ in await NotificationCenter.default.notifications(named: UIApplication.willResignActiveNotification) {
        WidgetCenter.shared.reloadAllTimelines()
      }
    }
  }

  func provide(_ items: [Item.WithProject]) {
    printError {
      try JSONEncoder()
        .encode(items)
        .write(to: Config.containerURL.appending(path: Self.filename))
    }
  }

  func receive() -> [Item.WithProject] {
    printError {
      try JSONDecoder()
        .decode(
          [Item.WithProject].self,
          from: try Data(contentsOf: Config.containerURL.appending(path: Self.filename))
        )
    } ?? []
  }
}

private extension WidgetController {
  static let filename = "WidgetData.json"

  @MainActor func updateWidgetsOnResignActive() async {}
}
