//	Created by Leopold Lemmermann on 04.12.22.

import DatabaseService
import Errors

extension MainState {
  @MainActor func setWidgets(on event: DatabaseEvent) async {
    await printError {
      widgetService.provide(
        try await privateDBService
          .fetchAndCollect(Query<Item>(\.isDone, .equal, false))
          .compactMap { [weak self] item in
            (try await self?.privateDBService.fetch(with: item.project) as Project?)
              .flatMap { Item.WithProject(item, project: $0) }
          }
      )
    }
  }
}
