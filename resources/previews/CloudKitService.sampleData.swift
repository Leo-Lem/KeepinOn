//	Created by Leopold Lemmermann on 24.10.22.

import Concurrency
import Errors
import CloudKitService
import LeosMisc
import SwiftUI

extension CommunityView {
  @ViewBuilder func testDataButtons() -> some View {
    AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
      await (mainState.publicDBService as? CloudKitService)?.createSampleData()
    } label: {
      Label("Add data", systemImage: "text.badge.plus")
    }

    AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
      await (mainState.publicDBService as? CloudKitService)?.deleteAll()
    } label: {
      Label("Delete All", systemImage: "text.badge.xmark")
    }
  }
}

extension CloudKitService {
  @MainActor func createSampleData() async {
    var convertibles = [any DatabaseObjectConvertible]()

    // creating users
    for user in [User.example, .example, .example] {
      convertibles.append(user)

      let sharedProject = SharedProject(.example, owner: user.id)
      convertibles.append(sharedProject)

      // creating items,
      for itemID in sharedProject.items {
        let sharedItem = SharedItem(
          id: itemID,
          title: Item.example.title,
          details: Item.example.details,
          isDone: Item.example.isDone,
          project: sharedProject.id
        )
        convertibles.append(sharedItem)
      }

      // creating comments
      for _ in 0 ..< Int.random(in: 3 ... 10) {
        convertibles.append(Comment(
          content: Comment.example.content,
          project: sharedProject.id,
          poster: user.id
        ))
      }
    }

    await printError {
      try await insert(convertibles).collect()
      await sleep(for: .seconds(1))
    }
  }

  @MainActor func deleteAll() async {
    await printError {
      try await deleteAll(User.self) // delete will cascade to all other types
    }
  }
}
