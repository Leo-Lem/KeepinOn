//	Created by Leopold Lemmermann on 24.10.22.

import Foundation

struct User: Identifiable, Hashable, Codable {
  let id: String

  var name: String,
      colorID: ColorID,
      progress: Award.Progress

  init(
    id: String,
    name: String = "",
    colorID: ColorID = .darkBlue,
    progress: Award.Progress = .init()
  ) {
    self.id = id
    self.name = name
    self.colorID = colorID
    self.progress = progress
  }
}
