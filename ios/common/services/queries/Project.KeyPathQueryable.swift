//	Created by Leopold Lemmermann on 27.10.22.

extension Project: KeyPathQueryable {
  static let keyPathDictionary: [PartialKeyPath<Self>: String] = [
    \.id: "id",
    \.title: "title",
    \.details: "details",
    \.isClosed: "isClosed",
    \.colorID: "colorID",
    \.reminder: "reminder"
  ]
}
