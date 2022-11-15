//	Created by Leopold Lemmermann on 25.10.22.

extension User: HasExample {
  static var example: User {
    User(
      id: .random(in: 4 ..< 15, using: .alphanumerics),
      name: .random(in: 4 ..< 20, using: .letters),
      progress: Award.Progress(),
      projects: [Project.Shared.ID(), Project.Shared.ID(), Project.Shared.ID()],
      comments: [Comment.ID(), Comment.ID(), Comment.ID()]
    )
  }
}
