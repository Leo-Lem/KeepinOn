//	Created by Leopold Lemmermann on 24.10.22.

import Foundation

struct SharedItem: Identifiable, Hashable {
  let id: Item.ID

  var title: String,
      details: String,
      isDone: Bool,
      project: SharedProject.ID
}

extension SharedItem {
  init(_ item: Item) {
    id = item.id
    title = item.title
    details = item.details
    isDone = item.isDone
    project = item.project
  }
}
