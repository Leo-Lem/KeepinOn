//	Created by Leopold Lemmermann on 05.10.22.

import CoreDataService
import Errors
import LeosMisc
import SwiftUI

extension HomeView {
  @ViewBuilder func testDataButtons() -> some View {
    AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
      await (mainState.privateDBService as? CoreDataService)?.createSampleData()
    } label: {
      Label("Add data", systemImage: "text.badge.plus")
    }

    AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
      await (mainState.privateDBService as? CoreDataService)?.deleteAll()
    } label: {
      Label("Delete All", systemImage: "text.badge.xmark")
    }
  }
}

extension CoreDataService {
  func createSampleData() async {
    await printError {
      for project in [Project.example, .example, .example] {
        await insert(project)

        for itemID in project.items {
          let example = Item.example
          let item = Item(
            id: itemID,
            title: example.title,
            details: example.details,
            isDone: example.isDone,
            priority: example.priority,
            project: project.id
          )
          await insert(item)
        }
      }
    }
  }

  func deleteAll() async {
    await printError {
      try await deleteAll(Project.self)
      try await deleteAll(Item.self)
    }
  }
}
