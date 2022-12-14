// Created by Leopold Lemmermann on 08.12.22.

import Previews

extension Item.WithProject: HasExample {
  static var example: Item.WithProject {
    Item.WithProject(.example, project: .example)
  }
}
