//	Created by Leopold Lemmermann on 24.10.22.

import Foundation

struct SharedProject: Identifiable, Hashable, Codable {
  let id: Project.ID

  var title: String,
      details: String,
      isClosed: Bool,
      items: [SharedItem.ID],
      comments: [Comment.ID],
      owner: User.ID
}

extension SharedProject {
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
