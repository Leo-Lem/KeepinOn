//	Created by Leopold Lemmermann on 27.10.22.

extension Comment: KeyPathQueryable {
  static let propertyNames: [PartialKeyPath<Self>: String] = [
    \.id: "id",
    \.timestamp: "timestamp",
    \.content: "content",
    \.project: "project",
    \.poster: "poster"
  ]
}
