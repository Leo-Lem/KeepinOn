//	Created by Leopold Lemmermann on 24.10.22.

import Foundation
import Colors

struct SharedProject: Identifiable, Hashable, Codable {
  let id: Project.ID

  var title: String,
      details: String,
      isClosed: Bool,
      colorID: ColorID,
      owner: User.ID
}

extension SharedProject {
  init(
    _ project: Project,
    owner: String
  ) {
    id = project.id
    title = project.title
    details = project.details
    isClosed = project.isClosed
    colorID = project.colorID
    self.owner = owner
  }
}
