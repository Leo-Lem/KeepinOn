//	Created by Leopold Lemmermann on 25.10.22.

import Foundation

struct Comment: Identifiable, Hashable, Codable {
  let id: UUID,
      timestamp: Date
  
  var content: String,
      project: SharedProject.ID,
      poster: User.ID

  init(
    id: ID = ID(),
    timestamp: Date = .now,
    content: String,
    project: SharedProject.ID,
    poster: User.ID
  ) {
    self.id = id
    self.timestamp = timestamp
    self.content = content
    self.project = project
    self.poster = poster
  }
}
