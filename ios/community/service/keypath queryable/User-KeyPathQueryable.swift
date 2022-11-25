//	Created by Leopold Lemmermann on 28.10.22.

extension User: KeyPathQueryable {
  static let propertyNames: [PartialKeyPath<Self>: String] = [
    \.id: "id",
    \.name: "name",
    \.colorID: "colorID"
  ]
}
