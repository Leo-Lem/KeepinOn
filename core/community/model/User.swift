//	Created by Leopold Lemmermann on 24.10.22.

import Foundation

struct User: Identifiable, Hashable, Codable {
  let id: String

  var name: String,
      colorID: ColorID,
      projects: [SharedProject.ID],
      comments: [Comment.ID]

  init(
    id: ID,
    name: String = "",
    colorID: ColorID = .darkBlue,
    projects: [SharedProject.ID] = [],
    comments: [Comment.ID] = []
  ) {
    self.id = id
    self.name = name
    self.colorID = colorID
    self.projects = projects
    self.comments = projects
  }
}
