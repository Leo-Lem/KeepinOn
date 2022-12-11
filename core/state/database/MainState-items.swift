// Created by Leopold Lemmermann on 08.12.22.

import Errors

extension MainState {
  @MainActor func toggleItemIsDone(with id: Item.ID) async {
    await printError {
      try await privateDBService.modify(Item.self, with: id) { item in
        item.isDone.toggle()
        let isDone = item.isDone
        Task { if isDone { await printError(awardsService.completedItem) } }
      }
    }
  }

  @MainActor func updateItem(_ item: Item) async {
    await printError { try await privateDBService.insert(item) }
  }

  @MainActor func deleteItem(with id: Item.ID) async {
    await printError {
      if try await publicDBService.exists(SharedItem.self, with: id) {
        try await displayError {
          try await publicDBService.delete(SharedItem.self, with: id)
        }
      }

      try await privateDBService.delete(Item.self, with: id)
    }
  }
}
