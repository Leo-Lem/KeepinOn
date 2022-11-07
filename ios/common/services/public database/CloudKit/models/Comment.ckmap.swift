//	Created by Leopold Lemmermann on 25.10.22.

import CloudKit

extension Comment: CKConvertible {
  static let ckIdentifier = "Comment"

  init(from record: CKRecord, refs: [CKRecord] = []) {
    let id = UUID(uuidString: record.recordID.recordName) ?? UUID()
    let timestamp = record["timestamp"] as? Date ?? .now
    let content = record["content"] as? String ?? ""

    let project: Project.Shared? = Self.getSimpleRef(from: refs)
    let postedBy: User? = Self.getSimpleRef(from: refs)

    self.init(id: id, timestamp: timestamp, project: project, postedBy: postedBy, content: content)
  }

  func mapToCKRecord(existing record: CKRecord? = nil) -> CKRecord {
    let record = record ?? CKRecord(
      recordType: Self.ckIdentifier,
      recordID: .init(recordName: id.uuidString)
    )

    record.setValuesForKeys([
      "timestamp": timestamp,
      "content": content
    ])

    if let project = project {
      record[type(of: project).referenceID] = CKRecord.Reference(
        recordID: .init(recordName: project.id.uuidString), action: .deleteSelf
      )
    }

    if let postedBy = postedBy {
      record[type(of: postedBy).referenceID] = CKRecord.Reference(
        recordID: .init(recordName: postedBy.id), action: .deleteSelf
      )
    }

    return record
  }
}
