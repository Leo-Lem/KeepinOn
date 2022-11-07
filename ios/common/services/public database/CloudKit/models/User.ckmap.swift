//	Created by Leopold Lemmermann on 28.10.22.

import CloudKit

extension User: CKConvertible {
  static let ckIdentifier = "User"

  init(from record: CKRecord, refs: [CKRecord] = []) {
    let id = record.recordID.recordName
    let name = record["name"] as? String ?? ""
    let colorID = ColorID(rawValue: record["colorID"] as? String ?? "") ?? .darkBlue
    let progress: Award.Progress = (record["progress"] as? Data)
      .flatMap { data in try? JSONDecoder().decode(Award.Progress.self, from: data) }
      ?? Award.Progress()

    self.init(
      id: id,
      name: name,
      colorID: colorID,
      progress: progress
    )
  }

  func mapToCKRecord(existing record: CKRecord? = nil) -> CKRecord {
    let record = record ?? CKRecord(
      recordType: Self.ckIdentifier,
      recordID: CKRecord.ID(recordName: id)
    )

    record.setValuesForKeys([
      "name": name,
      "colorID": colorID.rawValue,
      "progress": (try? JSONEncoder().encode(progress)) ?? Data()
    ])

    return record
  }
}
