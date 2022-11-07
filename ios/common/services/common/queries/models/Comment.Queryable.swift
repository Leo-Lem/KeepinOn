//	Created by Leopold Lemmermann on 27.10.22.

extension Comment: Queryable {
  static let keyPathDictionary: [PartialKeyPath<Self>: String] = [
    \.id: "id",
    \.timestamp: "timestamp",
    \.project: "project",
    \.postedBy: "postedBy",
    \.content: "content"
  ]
}
