//	Created by Leopold Lemmermann on 21.10.22.

protocol Queryable {
  static var keyPathDictionary: [PartialKeyPath<Self>: String] { get }
}
