// Created by Leopold Lemmermann on 11.12.22.

import CoreDataService
import Errors

extension MainState {
  @MainActor func setProjectLimitReached(on event: DatabaseEvent) async {
    await printError {
      let projectsCount = try await privateDBService
        .fetchAndCollect(Query<Project>(\.isClosed, .equal, false)).count
      projectLimitReached = projectsCount >= Config.freeLimits.projects
    }
  }
}
