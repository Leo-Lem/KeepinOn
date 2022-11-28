//	Created by Leopold Lemmermann on 25.10.22.

import CloudKit

extension Comment: RemoteConvertible {
  typealias RemoteModel = CKRecord
  static let typeID = "Comment"

  init(from remoteModel: RemoteModel) {
    let id = UUID(uuidString: remoteModel.recordID.recordName) ?? UUID()
    let project = remoteModel["project"] as? CKRecord.Reference
    let poster = remoteModel["poster"] as? CKRecord.Reference
    
    self.init(
      id: id,
      timestamp: remoteModel["timestamp"] as? Date ?? .now,
      content: remoteModel["content"] as? String ?? "",
      project: (project?.recordID.recordName).flatMap(SharedProject.ID.init) ?? SharedProject.ID(),
      poster: (poster?.recordID.recordName) ?? User.ID()
    )
    
    if project == nil { debugPrint("Faulty Project reference in Comment with id \(id).")}
    if poster == nil { debugPrint("Faulty Poster reference in Comment with id \(id).")}
  }

  func mapProperties(onto remoteModel: RemoteModel) -> RemoteModel {
    remoteModel.setValuesForKeys([
      "timestamp": timestamp,
      "content": content,
      "project": Self.mapValue(for: \.project, input: project),
      "poster": Self.mapValue(for: \.poster, input: poster)
    ])

    return remoteModel
  }
}
