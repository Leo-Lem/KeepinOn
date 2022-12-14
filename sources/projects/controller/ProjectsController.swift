// Created by Leopold Lemmermann on 13.12.22.

import Concurrency
import DatabaseService
import Foundation
import IndexingService
import PushNotificationService
import AwardsController

@MainActor class ProjectsController: ObservableObject {
  @Published var sortOrder: Item.SortOrder = .optimized
  @Published var canSendReminders: Bool?
  @Published var projectsLimitReached: Bool!
  
  let databaseService: any DatabaseService
  let indexingService: IndexingService
  let notificationService: any PushNotificationService
  
  private let tasks = Tasks()
  
  init(
    databaseService: any DatabaseService,
    indexingService: IndexingService,
    notificationService: any PushNotificationService
  ) async {
    self.databaseService = databaseService
    self.indexingService = indexingService
    self.notificationService = notificationService
    
    projectsLimitReached = await getProjectsLimitReached()
    canSendReminders = getCanSendReminders()
    
    tasks.add(
      databaseService.handleEventsTask(.background) { [weak self] event in
        await self?.setProjectLimitReached(on: event)
        await self?.setIndex(on: event)
      },
      notificationService.handleEventsTask(.background, with: setCanSendReminders)
    )
  }
}
