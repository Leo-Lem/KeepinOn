//	Created by Leopold Lemmermann on 24.11.22.

import CloudKit

extension SharedItem {
  static func mapValue<I>(for keyPath: KeyPath<Self, I>, input: I) -> Any {
    switch keyPath {
    case \.project:
      if let input = input as? any CustomStringConvertible {
        return CKRecord.Reference(recordID: .init(recordName: input.description), action: .deleteSelf)
      } else { return input }
    default:
      return input
    }
  }
}
