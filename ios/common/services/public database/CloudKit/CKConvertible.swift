//	Created by Leopold Lemmermann on 25.10.22.

import CloudKit

protocol CKConvertible: PublicModelConvertible {
  static var ckIdentifier: String { get }

  init(from record: CKRecord, refs: [CKRecord])
  func mapToCKRecord(existing record: CKRecord?) -> CKRecord
}

extension CKConvertible {
  static var referenceID: String { ckIdentifier.lowercased() }

  init(from record: CKRecord) {
    self.init(from: record, refs: [])
  }

  func mapToCKRecord() -> CKRecord {
    self.mapToCKRecord(existing: nil)
  }

  static func getSimpleRef<T: CKConvertible>(from refs: [CKRecord]) -> T? {
    refs
      .first { $0.recordType == T.ckIdentifier }
      .flatMap { T(from: $0) }
  }
}
