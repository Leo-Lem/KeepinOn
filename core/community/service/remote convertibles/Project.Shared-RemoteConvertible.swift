//	Created by Leopold Lemmermann on 25.10.22.

import CloudKit

extension SharedProject: RemoteConvertible {
  typealias RemoteModel = CKRecord
  static let typeID = "Project"

  init(from remoteModel: RemoteModel) {
    let id = ID(uuidString: remoteModel.recordID.recordName) ?? ID()
    let items = remoteModel["items"] as? [CKRecord.Reference]
    let comments = remoteModel["comments"] as? [CKRecord.Reference]
    let owner = remoteModel["owner"] as? CKRecord.Reference

    self.init(
      id: id,
      title: remoteModel["title"] as? String ?? "",
      details: remoteModel["details"] as? String ?? "",
      isClosed: remoteModel["isClosed"] as? Bool ?? false,
      items: items?
        .map(\.recordID.recordName)
        .compactMap(Item.ID.init) ?? [],
      comments: comments?
        .map(\.recordID.recordName)
        .compactMap(Comment.ID.init) ?? [],
      owner: (owner?.recordID.recordName) ?? User.ID()
    )

    if items == nil { debugPrint("Faulty Items reference in Project with id \(id).") }
    if comments == nil { debugPrint("Faulty Comments reference in Project with id \(id).") }
    if owner == nil { debugPrint("Faulty Owner reference in Project with id \(id).") }
  }

  func mapProperties(onto remoteModel: RemoteModel) -> RemoteModel {
    remoteModel.setValuesForKeys([
      "title": title,
      "details": details,
      "isClosed": isClosed,
      "items": Self.mapValue(for: \.items, input: items),
      "comments": Self.mapValue(for: \.comments, input: comments),
      "owner": Self.mapValue(for: \.owner, input: owner)
    ])

    return remoteModel
  }
}
