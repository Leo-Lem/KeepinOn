//	Created by Leopold Lemmermann on 25.10.22.

import CloudKit

extension Project.Shared: CKConvertible {
  static let ckIdentifier = "Project"

  init(from record: CKRecord, refs: [CKRecord] = []) {
    let id = UUID(uuidString: record.recordID.recordName) ?? UUID()
    let title = record["title"] as? String ?? ""
    let details = record["details"] as? String ?? ""
    let isClosed = record["isClosed"] as? Bool ?? false

    let owner: User? = Self.getSimpleRef(from: refs)

    self.init(
      id: id, title: title, details: details, isClosed: isClosed, owner: owner
    )
  }
  
  func mapToCKRecord(existing record: CKRecord? = nil) -> CKRecord {
    let record = record ?? CKRecord(
      recordType: Self.ckIdentifier,
      recordID: .init(recordName: id.uuidString)
    )
    
    record.setValuesForKeys([
      "title": title,
      "details": details,
      "isClosed": isClosed
    ])

    if let owner = owner {
      record[type(of: owner).referenceID] = CKRecord.Reference(
        recordID: .init(recordName: owner.id), action: .deleteSelf
      )
    }

    return record
  }
}
