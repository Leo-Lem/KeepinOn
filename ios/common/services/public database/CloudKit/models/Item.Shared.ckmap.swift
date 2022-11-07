//	Created by Leopold Lemmermann on 25.10.22.

import CloudKit

extension Item.Shared: CKConvertible {
  static let ckIdentifier = "Item"

  init(from record: CKRecord, refs: [CKRecord] = []) {
    let id = UUID(uuidString: record.recordID.recordName) ?? UUID()
    let title = record["title"] as? String ?? ""
    let details = record["details"] as? String ?? ""
    let isDone = record["isDone"] as? Bool ?? false

    let project: Project.Shared? = Self.getSimpleRef(from: refs)

    self.init(
      id: id, project: project, title: title, details: details, isDone: isDone
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
      "isDone": isDone
    ])

    if let project = project {
      record[type(of: project).referenceID] = CKRecord.Reference(
        recordID: .init(recordName: project.id.uuidString), action: .deleteSelf
      )
    }

    return record
  }
}
