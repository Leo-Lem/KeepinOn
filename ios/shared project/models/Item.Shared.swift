//	Created by Leopold Lemmermann on 24.10.22.

import Foundation

extension Item {
  struct Shared: Identifiable, Hashable {
    let id: UUID
    var project: Project.Shared?,
        title: String,
        details: String,
        isDone: Bool
  }
}

extension Item.Shared {
  init(_ item: Item, owner: User?) {
    id = item.id
    project = item.project.flatMap { Project.Shared($0, owner: owner) }
    title = item.title
    details = item.details
    isDone = item.isDone
  }
}
