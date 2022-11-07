//	Created by Leopold Lemmermann on 24.10.22.

extension Project.Shared: Queryable {
  static let keyPathDictionary: [PartialKeyPath<Self>: String] = [
    \.id: "id",
    \.title: "title",
    \.details: "details",
    \.isClosed: "isClosed",
    \.owner: "owner"
  ]
}
