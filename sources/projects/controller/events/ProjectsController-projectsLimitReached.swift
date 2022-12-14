// Created by Leopold Lemmermann on 11.12.22.

import CoreDataService
import Errors

extension ProjectsController {
  func getProjectsLimitReached() async -> Bool {
    await printError {
      try await databaseService
        .fetchAndCollect(Query<Project>(\.isClosed, .equal, false)).count >= Config.freeLimits.projects
    } ?? true
  }
  
  func setProjectLimitReached(on event: DatabaseEvent) async {
    projectsLimitReached = await getProjectsLimitReached()
  }
}
