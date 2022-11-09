//	Created by Leopold Lemmermann on 24.10.22.

import Foundation

extension Item {
  struct Shared: Identifiable, Hashable {
    let id: UUID
    var project: UUID?,
        title: String,
        details: String,
        isDone: Bool
  }
}

extension Item.Shared {
  init(_ item: Item) {
    id = item.id
    project = item.project
    title = item.title
    details = item.details
    isDone = item.isDone
  }
}
