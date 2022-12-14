//	Created by Leopold Lemmermann on 24.10.22.

import Colors
import Foundation

struct User: Identifiable, Hashable, Codable {
  let id: String

  var name: String
  var colorID: ColorID, avatarID: AvatarID
  var progress: Award.Progress

  init(
    id: ID,
    name: String = "",
    colorID: ColorID = .darkBlue,
    avatarID: AvatarID = .person,
    progress: Award.Progress = .init()
  ) {
    self.id = id
    self.name = name
    self.colorID = colorID
    self.avatarID = avatarID
    self.progress = progress
  }
}
