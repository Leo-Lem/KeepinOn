//  Created by Leopold Lemmermann on 09.10.2022.

import Concurrency
import Errors
import Foundation
import InAppPurchaseService
import LocalDatabaseService
import RemoteDatabaseService

extension ProjectsView {
  @MainActor final class ViewModel: KeepinOn.ViewModel {
    let closed: Bool

    // view state
    @Published var isPurchasing = false
    @Published var itemSortOrder: Item.SortOrder = .optimized

    // meta
    @Published private(set) var isPremium = false

    // data
    @Published private(set) var projects = [Project]()
    @Published private(set) var items = [Project.ID: [Item]]()

    let dismiss: () -> Void

    init(closed: Bool, dismiss: @escaping () -> Void, mainState: MainState) {
      self.closed = closed
      self.dismiss = dismiss

      super.init(mainState: mainState)

      loadProjectsAndItems()

      tasks.add(
        mainState.didChange.getTask(.high, operation: updateIsPremium),
        localDBService.didChange.getTask(operation: updateProjectsAndItems)
      )
    }
  }
}

extension ProjectsView.ViewModel {
  func addProject() {
    guard isPremium || projects.count < Config.freeLimits.projects else { return isPurchasing = true }
    
    printError {
      try localDBService.insert(Project())
    }
  }

  func addItem(to project: Project) {
    guard let count = items[project.id]?.count else { return }
    guard isPremium || count < Config.freeLimits.items else { return isPurchasing = true }

    printError {
      let item = Item(project: project.id)
      var project = project
      project.items.append(item.id)

      try localDBService.insert(item)
      try localDBService.insert(project)
      Task(priority: .userInitiated) {
        await printError {
          try await awardsService.addedItem()
        }
      }
    }
  }
}

private extension ProjectsView.ViewModel {
  func updateIsPremium(on change: MainState.Change) {
    if case let .isPremium(isPremium) = change { self.isPremium = isPremium }
  }

  func updateProjectsAndItems(on change: LocalDatabaseChange) { loadProjectsAndItems() }

  func loadProjectsAndItems() {
    printError {
      projects = try localDBService.fetch(Query<Project>(\.isClosed, .equal, closed))

      for project in projects {
        items[project.id] = printError { try project.items.compactMap(localDBService.fetch) }
      }
    }
  }
}
