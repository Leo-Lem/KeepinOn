//	Created by Leopold Lemmermann on 24.10.22.

extension SharedProject: HasExample {
  static var example: SharedProject {
    SharedProject(
      .example,
      owner: User.example.id,
      comments: [Comment.ID(), Comment.ID(), Comment.ID()]
    )
  }
}
