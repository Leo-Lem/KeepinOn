//	Created by Leopold Lemmermann on 07.10.22.

import Foundation

extension HomeView {
  final class ViewModel: KeepinOn.ViewModel {
    @Published private(set) var projectsWithItems = [Project.WithItems]()
    @Published private(set) var itemsWithProject = [Item.WithProject]()

    override init(appState: AppState) {
      super.init(appState: appState)

      loadProjectsAndItems()

      tasks.add(privDBService.didChange.getTask(with: updateProjectsAndItems))
    }
  }
}

extension HomeView.ViewModel {
  var upNext: [Item.WithProject] {
    [Item.WithProject](itemsWithProject.prefix(3))
  }

  var moreItems: [Item.WithProject] {
    [Item.WithProject](itemsWithProject.dropFirst(3))
  }

  func startEditing(_ project: Project) {
    routingService.route(to: .sheet(.editProject(project)))
  }

  func showInfo(for projectWithItems: Project.WithItems) {
    routingService.route(to: .sheet(.project(projectWithItems)))
  }

  func startEditing(_ item: Item) {
    routingService.route(to: .sheet(.editItem(item)))
  }

  func showInfo(for itemWithProject: Item.WithProject) {
    let item = itemWithProject.item
    let projectWithItems = Project.WithItems(itemWithProject.project, service: privDBService)
    
    routingService.route(
      to: .sheet(.item(item, projectWithItems: projectWithItems))
    )
  }
}

private extension HomeView.ViewModel {
  func loadProjectsAndItems() {
    printError {
      projectsWithItems = try privDBService
        .fetch(Query<Project>(\.isClosed, .equal, false))
        .map { project in Project.WithItems(project, service: privDBService) }

      itemsWithProject = try privDBService
        .fetch(Query<Item>(\.isDone, .equal, false))
        .compactMap { item in Item.WithProject(item, service: privDBService) }
    }
  }

  func updateProjectsAndItems(on change: PrivDBChange) {
    loadProjectsAndItems()
  }
}
