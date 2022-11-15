//	Created by Leopold Lemmermann on 09.11.22.

extension Project.WithItems: HasExample {
  static var example: Project.WithItems {
    Project.WithItems(
      .example,
      items: [.example, .example, .example]
    )
  }
}
