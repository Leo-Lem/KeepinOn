//	Created by Leopold Lemmermann on 24.10.22.

extension Project.Shared: HasExample {
  static var example: Project.Shared {
    Project.Shared(
      .example,
      owner: User.example.id,
      comments: [Comment.ID(), Comment.ID(), Comment.ID()]
    )
  }
}
