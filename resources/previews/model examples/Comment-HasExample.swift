//	Created by Leopold Lemmermann on 25.10.22.

extension Comment: HasExample {
  static var example: Comment {
    Comment(
      content: .random(in: 20 ..< 250, using: .letters.union(.whitespacesAndNewlines)),
      project: Project.Shared.example.id,
      poster: User.example.id
    )
  }
}
