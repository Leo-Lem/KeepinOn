//	Created by Leopold Lemmermann on 30.10.22.

import CloudKit

extension Credential: CKConvertible {
  static let ckIdentifier = "Credential"

  init(from record: CKRecord, refs: [CKRecord] = []) {
    let id = record.recordID.recordName
    let pin = record["pin"] as? String

    self.init(
      id: id,
      pin: pin
    )
  }

  func mapToCKRecord(existing record: CKRecord? = nil) -> CKRecord {
    let record = record ?? CKRecord(
      recordType: Self.ckIdentifier,
      recordID: CKRecord.ID(recordName: id)
    )

    record["pin"] = pin

    return record
  }
}
