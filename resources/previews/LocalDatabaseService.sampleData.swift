//	Created by Leopold Lemmermann on 05.10.22.

import Errors
import LocalDatabaseService

extension LocalDatabaseService {
  func createSampleData() {
    printError {
      for project in [Project.example, .example, .example] {
        try insert(project)

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
          try insert(item)
        }
      }
    }
  }

  func deleteAll() {
    printError {
      try deleteAll(Project.self)
      try deleteAll(Item.self)
    }
  }
}
