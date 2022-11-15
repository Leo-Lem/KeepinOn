//	Created by Leopold Lemmermann on 24.10.22.

import Foundation

extension Item {
  struct Shared: Identifiable, Hashable {
    let id: Item.ID
    
    var title: String,
        details: String,
        isDone: Bool,
        project: Project.Shared.ID
  }
}

extension Item.Shared {
  init(_ item: Item) {
    id = item.id
    title = item.title
    details = item.details
    isDone = item.isDone
    project = item.project
  }
}

extension Item.Shared {
  struct WithProject: Identifiable, Hashable {
    let item: Item.Shared,
        project: Project.Shared
    
    var id: Item.Shared.ID { item.id }
    
    init(_ item: Item.Shared, project: Project.Shared) {
      self.item = item
      self.project = project
    }
  }
}
