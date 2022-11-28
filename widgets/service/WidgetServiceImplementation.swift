//	Created by Leopold Lemmermann on 09.11.22.

import Combine
import Concurrency
import Errors
import WidgetKit

class WidgetServiceImplementation: WidgetService {
  private let tasks = Tasks()

  init() {
    tasks.add(updateWidgetsOnResignActive())
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

private extension WidgetServiceImplementation {
  static let filename = "WidgetData.json"
  
  func updateWidgetsOnResignActive() -> Task<Void, Never> {
    resignActivePublisher().getTask { _ in WidgetCenter.shared.reloadAllTimelines() }
  }
}
