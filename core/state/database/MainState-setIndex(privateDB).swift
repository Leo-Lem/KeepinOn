//	Created by Leopold Lemmermann on 04.12.22.

import DatabaseService
import Errors
import IndexingService

extension MainState {
  @MainActor func setIndex(on event: DatabaseEvent) async {
    await printError {
      switch event {
      case let .inserted(type, id):
        switch id {
        case let id as Project.ID where type == Project.self:
          if let project = try await privateDBService.fetch(with: id) as Project? {
            try await indexingService.updateReference(to: project)
          }
        case let id as Item.ID where type == Item.self:
          if let item = try await privateDBService.fetch(with: id) as Item? {
            try await indexingService.updateReference(to: item)
          }
        default: break
        }
      case let .deleted(_, id):
        try await indexingService.removeReference(with: id.description)
      default: break
      }
    }
  }
}
