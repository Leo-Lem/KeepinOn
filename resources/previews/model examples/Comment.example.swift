//	Created by Leopold Lemmermann on 25.10.22.

extension Comment: HasExample {
  static var example: Comment {
    Comment(
      project: .example,
      postedBy: .example,
      content: "Hello there, lovely project you have here!"
    )
  }
}
