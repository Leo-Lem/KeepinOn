//	Created by Leopold Lemmermann on 25.10.22.

import CloudKit

extension SharedItem: RemoteConvertible {
  typealias RemoteModel = CKRecord
  static let typeID = "Item"

  init(from remoteModel: RemoteModel) {
    let id = UUID(uuidString: remoteModel.recordID.recordName) ?? UUID()
    let project = remoteModel["project"] as? CKRecord.Reference

    self.init(
      id: id,
      title: remoteModel["title"] as? String ?? "",
      details: remoteModel["details"] as? String ?? "",
      isDone: remoteModel["isDone"] as? Bool ?? false,
      project: (project?.recordID.recordName).flatMap(SharedProject.ID.init) ?? SharedProject.ID()
    )

    if project == nil { debugPrint("Faulty Project reference in Item with id \(id).") }
  }

  func mapProperties(onto remoteModel: CKRecord) -> CKRecord {
    remoteModel.setValuesForKeys([
      "title": title,
      "details": details,
      "isDone": isDone,
      "project": Self.mapValue(for: \.project, input: project)
    ])

    return remoteModel
  }
}
