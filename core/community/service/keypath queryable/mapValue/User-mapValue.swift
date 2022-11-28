//	Created by Leopold Lemmermann on 24.11.22.

import CloudKit

extension User {
  static func mapValue<I>(for keyPath: KeyPath<Self, I>, input: I) -> Any {
    switch keyPath {
    case \.projects, \.comments:
      if let input = input as? [any CustomStringConvertible] {
        return input
          .map(\.description)
          .map(CKRecord.ID.init)
          .map { CKRecord.Reference(recordID: $0, action: .none) }
      } else { return input }
    default:
      return input
    }
  }
}
