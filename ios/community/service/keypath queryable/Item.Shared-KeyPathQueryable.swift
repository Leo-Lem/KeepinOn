//	Created by Leopold Lemmermann on 27.10.22.

extension SharedItem: KeyPathQueryable {
  static let propertyNames: [PartialKeyPath<Self>: String] = [
    \.id: "id",
    \.project: "project",
    \.title: "title",
    \.details: "details",
    \.isDone: "isDone"
  ]
}
