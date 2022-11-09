//	Created by Leopold Lemmermann on 09.11.22.

extension Item.WithProject: HasExample {
  static var example: Item.WithProject {
    Item.WithProject(
      .example,
      project: .example
    )
  }
}
