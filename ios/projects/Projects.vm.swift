//  Created by Leopold Lemmermann on 09.10.2022.

import Foundation

extension ProjectsView {
  @MainActor final class ViewModel: KeepinOn.ViewModel {
    let closed: Bool

    @Published private(set) var projectsWithItems = [Project.WithItems]()
    @Published private var isPremium: Bool = false

    init(closed: Bool, appState: AppState) {
      self.closed = closed

      super.init(appState: appState)

      loadProjects()
      loadIsPremium()

      tasks.add(
        privDBService.didChange.getTask(with: updateProjects),
        purchaseService.didChange.getTask(with: loadIsPremium)
      )
    }
  }
}

extension ProjectsView.ViewModel {
  var sortOrder: Item.SortOrder {
    get { appState.settings.itemSortOrder }
    set { appState.settings.itemSortOrder = newValue }
  }

  // pruchasing
  func startPurchase() {
    routingService.route(to: Sheet.purchase)
  }

  // projects

  func addProject() {
    if isPremium || projectsWithItems.count < config.freeLimits.projects {
      printError {
        try privDBService.insert(Project())
      }
    } else {
      startPurchase()
    }
  }

  func delete(project: Project) async {
    await routingService.routeAndWaitForReturn(
      to: .alert(
        .delete(
          project: project,
          fulfill: { [weak self] project in
            Task(priority: .userInitiated) {
              await self?.delete(project)
            }
          }
        )
      )
    )
  }

  func toggleIsClosed(for project: Project) {
    printError {
      var project = project
      project.isClosed.toggle()
      try privDBService.insert(project)
    }
  }

  func addItem(to project: Project) {
    if isPremium || project.items.count < config.freeLimits.items {
      printError {
        let item = Item(project: project.id)
        var project = project
        project.addItem(item)

        try privDBService.insert(item)
        try privDBService.insert(project)
        Task(priority: .userInitiated) {
          await printError {
            try await awardService.addedItem()
          }
        }
      }
    }
  }

  func delete(item: Item) {
    Task(priority: .userInitiated) { [weak self] in
      await self?.delete(item)
    }
  }

  func startEditing(item: Item) {
    routingService.route(to: .sheet(.editItem(item)))
  }

  func toggleIsDone(for item: Item) {
    printError {
      var item = item
      item.isDone.toggle()
      try privDBService.insert(item)

      Task(priority: .userInitiated) {
        if item.isDone {
          await printError {
            try await awardService.completedItem()
          }
        }
      }
    }
  }
}

private extension ProjectsView.ViewModel {
  func delete<T: PrivConvertible>(_ model: T) async {
    await printError {
      if try await publicDatabaseService.exists(with: model.stringID) {
        try await appState.showErrorAlert {
          try await publicDatabaseService.unpublish(with: model.stringID)
        }
      }

      try privDBService.delete(model)
    }
  }

  func loadProjects() {
    printError {
      projectsWithItems = try privDBService
        .fetch(Query<Project>(\.isClosed, .equal, closed))
        .map { project in
          Project.WithItems(
            project,
            items: project.attachItems(privDBService).items.sorted(using: sortOrder)
          )
        }
    }
  }

  func loadIsPremium() {
    isPremium = purchaseService.isPurchased(id: .fullVersion)
  }

  func updateProjects(on change: PrivDBChange) {
    loadProjects()
  }
}
