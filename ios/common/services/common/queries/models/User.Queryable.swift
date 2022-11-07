//	Created by Leopold Lemmermann on 28.10.22.

extension User: Queryable {
  static let keyPathDictionary: [PartialKeyPath<Self>: String] = [
    \.id: "id",
    \.name: "name",
    \.colorID: "colorID"
  ]
}
