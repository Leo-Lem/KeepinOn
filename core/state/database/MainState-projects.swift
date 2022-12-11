//	Created by Leopold Lemmermann on 07.12.22.

import CoreDataService
import CoreHapticsService
import Errors

extension MainState {
  @MainActor func toggleProjectIsClosed(_ project: Project) async {
    await printError {
      try await privateDBService.modify(Project.self, with: project.id) { project in
        project.isClosed.toggle()
      }
    }
  }

  @MainActor func updateProject(_ project: Project) async {
    await printError { try await privateDBService.insert(project) }

    if project.reminder != nil {
      await notificationService.schedule(KeepinOnNotification.reminder(project))
    } else {
      notificationService.cancel(KeepinOnNotification.reminder(project))
    }
  }

  @MainActor func deleteProject(_ project: Project) async {
    await printError {
      if try await publicDBService.exists(SharedProject.self, with: project.id) {
        try await displayError {
          try await publicDBService.delete(SharedProject.self, with: project.id)
        }
      }

      for itemID in project.items { try await privateDBService.delete(Item.self, with: itemID) }
      try await privateDBService.delete(project)
    }
  }
}
