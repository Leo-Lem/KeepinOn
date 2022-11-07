//	Created by Leopold Lemmermann on 24.10.22.

import Foundation

extension Project {
  struct Shared: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String,
        details: String,
        isClosed: Bool,
        owner: User?
  }
}

extension Project.Shared {
  init(_ project: Project, owner: User?) {
    id = project.id
    title = project.title
    details = project.details
    isClosed = project.isClosed
    self.owner = owner
  }
}
