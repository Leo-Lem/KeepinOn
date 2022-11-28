//	Created by Leopold Lemmermann on 27.10.22.

extension Item: KeyPathQueryable {
  static let propertyNames: [PartialKeyPath<Self>: String] = [
    \.id: "id",
    \.title: "title",
    \.details: "details",
    \.isDone: "isDone",
    \.priority: "priority",
    \.project: "project"
  ]
}
