//	Created by Leopold Lemmermann on 25.10.22.

import Foundation

struct Comment: Identifiable, Hashable {
  let id: UUID,
      timestamp: Date
  
  var content: String,
      project: Project.Shared.ID,
      poster: User.ID

  init(
    id: ID = ID(),
    timestamp: Date = .now,
    content: String,
    project: Project.Shared.ID,
    poster: User.ID
  ) {
    self.id = id
    self.timestamp = timestamp
    self.content = content
    self.project = project
    self.poster = poster
  }
}

extension Comment {
  struct WithProject: Identifiable, Hashable {
    let comment: Comment,
        project: Project.Shared
    
    var id: Comment.ID { comment.id }
    
    init(_ comment: Comment, project: Project.Shared) {
      self.comment = comment
      self.project = project
    }
  }
  
  struct WithPoster: Identifiable, Hashable {
    let comment: Comment,
        poster: User
    
    var id: Comment.ID { comment.id }
    
    init(_ comment: Comment, poster: User) {
      self.comment = comment
      self.poster = poster
    }
  }
}
