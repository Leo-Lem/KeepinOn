//	Created by Leopold Lemmermann on 04.12.22.

import DatabaseService
import Errors

extension Main {
  func setWidgets(on event: DatabaseEvent) async {
    if let widgetController, let databaseService = projectsController?.databaseService {
      await printError {
        widgetController.provide(
          try await databaseService
            .fetchAndCollect(Query<Item>(\.isDone, .equal, false))
            .compactMap { item in
              try await databaseService.fetch(Project.self, with: item.project).flatMap {
                Item.WithProject(item, project: $0)
              }
            }
        )
      }
    }
  }
}
