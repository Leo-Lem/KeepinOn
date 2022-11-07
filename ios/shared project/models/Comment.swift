//	Created by Leopold Lemmermann on 25.10.22.

import Foundation

struct Comment: Identifiable, Hashable {
  let id: UUID,
      timestamp: Date
  var project: Project.Shared?,
      postedBy: User?,
      content: String

  init(
    id: UUID = UUID(),
    timestamp: Date = .now,
    project: Project.Shared?,
    postedBy: User?,
    content: String
  ) {
    self.id = id
    self.timestamp = timestamp
    self.project = project
    self.postedBy = postedBy
    self.content = content
  }
}
