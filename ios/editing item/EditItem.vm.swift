//  Created by Leopold Lemmermann on 09.10.22.

import Foundation

extension EditItemView {
  @MainActor final class ViewModel: KeepinOn.ViewModel {
    private let item: Item

    @Published var title: String
    @Published var details: String
    @Published var priority: Item.Priority
    @Published private(set) var isDone: Bool

    init(item: Item, appState: AppState) {
      self.item = item

      title = item.title
      details = item.details
      isDone = item.isDone
      priority = item.priority

      super.init(appState: appState)
    }
  }
}

extension EditItemView.ViewModel {
  func setIsDone(_ new: Bool) {
    isDone = new
    updateItem()
    Task(priority: .userInitiated) {
      if new {
        await printError {
          try await awardService.completedItem()
        }
      }
    }
  }

  func updateItem() {
    var item = item
    item.title = title
    item.details = details
    item.isDone = isDone
    item.priority = priority

    do {
      try privateDatabaseService.insert(item)
    } catch { print(error.localizedDescription) }

    routingService.dismiss()
  }
}
