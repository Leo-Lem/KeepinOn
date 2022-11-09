//	Created by Leopold Lemmermann on 30.10.22.

extension Credential: KeyPathQueryable {
  static let keyPathDictionary: [PartialKeyPath<Self>: String] = [
    \.id: "id",
    \.pin: "pin"
  ]
}
