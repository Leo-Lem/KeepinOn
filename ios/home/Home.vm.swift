//	Created by Leopold Lemmermann on 07.10.22.

import Foundation

extension HomeView {
  final class ViewModel: KeepinOn.ViewModel {
    @Published private(set) var projects = [Project]()
    @Published private(set) var items = [Item]()

    override init(appState: AppState) {
      super.init(appState: appState)

      updateProjectsAndItems()

      tasks.add(
        privateDatabaseService.didChange.getTask(with: updateProjectsAndItems)
      )
    }
  }
}

extension HomeView.ViewModel {
  var upNext: [Item] {
    [Item](items.prefix(3))
  }

  var moreItems: [Item] {
    [Item](items.dropFirst(3))
  }

  func startEditing(_ project: Project) {
    routingService.route(to: .sheet(.editProject(project)))
  }

  func showInfo(for project: Project) {
    routingService.route(to: .sheet(.project(project)))
  }

  func startEditing(_ item: Item) {
    routingService.route(to: .sheet(.editItem(item)))
  }

  func showInfo(for item: Item) {
    routingService.route(to: .sheet(.item(item)))
  }
}

private extension HomeView.ViewModel {
  func updateProjectsAndItems() {
    let openProjectsQuery = Query<Project>(\.isClosed, .eq, false)
    let featuredItemsQuery = Query<Item>([
      .init(\.isDone, .eq, false)!,
      .init(\.project?.isClosed, .eq, false)!
    ], compound: .and)

    do {
      projects = try privateDatabaseService.fetch(openProjectsQuery)
      items = try privateDatabaseService.fetch(featuredItemsQuery)
    } catch { print(error) }
  }
}

#if DEBUG
  extension HomeView.ViewModel {
    func createSampleData() {
      if let service = privateDatabaseService as? CDService {
        service.createSampleData()
      }
    }

    func deleteAll() {
      if let service = privateDatabaseService as? CDService {
        service.deleteAll()
      }
    }
  }
#endif
