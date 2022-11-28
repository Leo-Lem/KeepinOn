//	Created by Leopold Lemmermann on 28.10.22.

import CloudKit

extension User: RemoteConvertible {
  typealias RemoteModel = CKRecord
  static let typeID = "User"

  init(from remoteModel: RemoteModel) {
    let id = remoteModel.recordID.recordName
    let projects = remoteModel["projects"] as? [CKRecord.Reference]
    let comments = remoteModel["comments"] as? [CKRecord.Reference]

    self.init(
      id: remoteModel.recordID.recordName,
      name: remoteModel["name"] as? String ?? "",
      colorID: ColorID(rawValue: remoteModel["colorID"] as? String ?? "") ?? .darkBlue,
      projects: projects?
        .map(\.recordID.recordName)
        .compactMap(SharedProject.ID.init) ?? [],
      comments: comments?
        .map(\.recordID.recordName)
        .compactMap(Comment.ID.init) ?? []
    )

    if projects == nil { debugPrint("Faulty Projects reference in User with id \(id).") }
    if comments == nil { debugPrint("Faulty Comments reference in User with id \(id).") }
  }

  func mapProperties(onto remoteModel: RemoteModel) -> RemoteModel {
    remoteModel.setValuesForKeys([
      "name": name,
      "colorID": colorID.rawValue,
      "projects": Self.mapValue(for: \.projects, input: projects),
      "comments": Self.mapValue(for: \.comments, input: comments)
    ])

    return remoteModel
  }
}
