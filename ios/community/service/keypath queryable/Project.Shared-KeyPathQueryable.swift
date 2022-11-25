//	Created by Leopold Lemmermann on 24.10.22.

extension SharedProject: KeyPathQueryable {
  static let propertyNames: [PartialKeyPath<Self>: String] = [
    \.id: "id",
    \.title: "title",
    \.details: "details",
    \.isClosed: "isClosed",
    \.owner: "owner"
  ]
}
