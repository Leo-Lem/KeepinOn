//	Created by Leopold Lemmermann on 24.10.22.

import Foundation

struct User: Identifiable, Hashable, Codable {
  let id: String

  var name: String,
      colorID: ColorID,
      progress: Award.Progress,
      projects: [Project.Shared.ID],
      comments: [Comment.ID]

  init(
    id: ID,
    name: String = "",
    colorID: ColorID = .darkBlue,
    progress: Award.Progress = .init(),
    projects: [Project.Shared.ID] = [],
    comments: [Comment.ID] = []
  ) {
    self.id = id
    self.name = name
    self.colorID = colorID
    self.progress = progress
    self.projects = projects
    self.comments = projects
  }
}

extension User {
  struct WithProjects: Identifiable, Hashable {
    let user: User,
        projects: [Project.Shared]
    
    var id: User.ID { user.id }
    
    init(_ user: User, projects: [Project.Shared]) {
      self.user = user
      self.projects = projects
    }
  }

  struct WithComments: Identifiable, Hashable {
    let user: User,
        comments: [Comment]
    
    var id: User.ID { user.id }
    
    init(_ user: User, comments: [Comment]) {
      self.user = user
      self.comments = comments
    }
  }
}
