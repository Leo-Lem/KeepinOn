//  Created by Leopold Lemmermann on 09.10.2022.

import Foundation

extension ProjectsView {
  @MainActor final class ViewModel: KeepinOn.ViewModel {
    let closed: Bool

    @Published private(set) var projects: [Project] = []
    @Published private var isPremium: Bool = false

    init(closed: Bool, appState: AppState) {
      self.closed = closed

      super.init(appState: appState)

      updateProjects()
      updateIsPremium()

      tasks.add(
        privateDatabaseService.didChange.getTask(with: updateProjects),
        purchaseService.didChange.getTask(with: updateIsPremium)
      )
    }
  }
}

extension ProjectsView.ViewModel {
  var sortOrder: Item.SortOrder {
    get { appState.settings.itemSortOrder }
    set { appState.settings.itemSortOrder = newValue }
  }
}

extension ProjectsView.ViewModel {
  func startPurchase() {
    routingService.route(to: Sheet.purchase)
  }

  func addProject() {
    if isPremium || projects.count < config.freeProjectsLimit {
      printError {
        let project = Project()
        projects.append(project)
        try privateDatabaseService.insert(project)
      }
    } else {
      startPurchase()
    }
  }

  func addItem(to project: Project) {
    let item = Item(project: project)

    printError {
      try privateDatabaseService.insert(item)
      Task(priority: .userInitiated) {
        await printError {
          try await awardService.itemsAdded(1)
        }
      }
    }
  }

  func delete(item: Item) {
    Task(priority: .userInitiated) { [weak self] in
      await self?.delete(with: item.id)
    }
  }

  func delete(project: Project) async {
    await routingService.routeAndWaitForReturn(
      to: .alert(
        .delete(
          project: project,
          fulfill: { [weak self] project in
            Task(priority: .userInitiated) {
              await self?.delete(with: project.id)
            }
          }
        )
      )
    )
  }

  func toggleIsDone(for item: Item) {
    printError {
      var item = item
      item.isDone.toggle()
      try privateDatabaseService.insert(item)

      Task(priority: .userInitiated) {
        if item.isDone {
          await printError {
            try await awardService.itemsCompleted(1)
          }
        }
      }
    }
  }

  func toggleIsClosed(for project: Project) {
    printError {
      var project = project
      project.isClosed.toggle()
      try privateDatabaseService.insert(project)
    }
  }

  func startEditing(item: Item) {
    routingService.route(to: .sheet(.editItem(item)))
  }
}

private extension ProjectsView.ViewModel {
  func delete(with id: UUID) async {
    await printError {
      if try await publicDatabaseService.exists(with: id.uuidString) {
        try await appState.showErrorAlert {
          try await publicDatabaseService.unpublish(with: id.uuidString)
        }
      }

      try privateDatabaseService.delete(with: id)
    }
  }

  func updateProjects() {
    let projectsQuery = Query<Project>(\.isClosed, .eq, closed)
    printError {
      projects = try privateDatabaseService.fetch(projectsQuery)
    }
  }

  func updateIsPremium() {
    isPremium = purchaseService.isPurchased(id: .fullVersion)
  }
}
