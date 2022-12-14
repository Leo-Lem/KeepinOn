// Created by Leopold Lemmermann on 14.12.22.

import DatabaseService
import Errors
import SwiftUI

extension ProjectsController {
  func loadItems(of project: Project, into items: Binding<[Item]>) async {
    await printError {
      items.wrappedValue.removeAll { item in !project.items.contains(where: { $0 == item.id }) }

      for try await item: Item in await databaseService.fetch(with: project.items) {
        insert(item, into: &items.wrappedValue)
      }
    }
  }

  func updateItems(of project: Project, on event: DatabaseEvent, into items: Binding<[Item]>) async {
    await printError {
      switch event {
      case let .inserted(type, id) where type == Item.self:
        if
          let id = id as? Item.ID,
          let item: Item = try await databaseService.fetch(with: id),
          item.project == project.id
        {
          insert(item, into: &items.wrappedValue)
        }
      case let .deleted(type, id) where type == Item.self:
        if let id = id as? Item.ID { remove(with: id, from: &items.wrappedValue) }
      case .remote:
        await loadItems(of: project, into: items)
      default:
        break
      }
    }
  }
}
