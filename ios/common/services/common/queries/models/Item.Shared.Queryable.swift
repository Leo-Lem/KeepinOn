//	Created by Leopold Lemmermann on 27.10.22.

extension Item.Shared: Queryable {
  static let keyPathDictionary: [PartialKeyPath<Self>: String] = [
    \.id: "id",
    \.project: "project",
    \.title: "title",
    \.details: "details",
    \.isDone: "isDone"
  ]
}
