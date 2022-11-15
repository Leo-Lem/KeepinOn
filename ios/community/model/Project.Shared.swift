//	Created by Leopold Lemmermann on 24.10.22.

import Foundation

extension Project {
  struct Shared: Identifiable, Hashable, Codable {
    let id: Project.ID

    var title: String,
        details: String,
        isClosed: Bool,
        items: [Item.Shared.ID],
        comments: [Comment.ID],
        owner: User.ID
  }
}

extension Project.Shared {
  init(
    _ project: Project,
    owner: String,
    comments: [Comment.ID] = []
  ) {
    id = project.id
    title = project.title
    details = project.details
    isClosed = project.isClosed
    items = project.items
    self.comments = comments
    self.owner = owner
  }
}

extension Project.Shared {
  struct WithOwner: Identifiable, Hashable {
    let project: Project.Shared,
        owner: User
    
    var id: Project.Shared.ID { project.id }
    
    init(_ project: Project.Shared, owner: User) {
      self.project = project
      self.owner = owner
    }
  }
  
  struct WithItems: Identifiable, Hashable {
    let project: Project.Shared,
        items: [Item.Shared]
    
    var id: Project.Shared.ID { project.id }
    
    init(_ project: Project.Shared, items: [Item.Shared]) {
      self.project = project
      self.items = items
    }
  }
  
  struct WithComments: Identifiable, Hashable {
    let project: Project.Shared,
        comments: [Comment]
    
    var id: Project.Shared.ID { project.id }
    
    init(_ project: Project.Shared, comments: [Comment]) {
      self.project = project
      self.comments = comments
    }
  }
}
