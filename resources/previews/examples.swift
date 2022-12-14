// Created by Leopold Lemmermann on 08.12.22.

import Previews

extension SharedProject: HasExample {
  static var example: SharedProject {
    SharedProject(
      .example,
      owner: User.example.id,
      comments: [Comment.ID(), Comment.ID(), Comment.ID()]
    )
  }
}

extension SharedItem: HasExample {
  static var example: SharedItem {
    SharedItem(.example)
  }
}

extension Comment: HasExample {
  static var example: Comment {
    Comment(
      content: .random(in: 20 ..< 250, using: .letters.union(.whitespacesAndNewlines)).localizedCapitalized,
      project: SharedProject.example.id,
      poster: User.example.id
    )
  }
}

extension User: HasExample {
  static var example: User {
    User(
      id: .random(in: 4 ..< 15, using: .alphanumerics),
      name: .random(in: 4 ..< 20, using: .letters).localizedCapitalized,
      projects: [SharedProject.ID(), SharedProject.ID(), SharedProject.ID()],
      comments: [Comment.ID(), Comment.ID(), Comment.ID()]
    )
  }
}
