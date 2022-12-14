//	Created by Leopold Lemmermann on 25.10.22.

import CloudKitService

extension SharedProject: DatabaseObjectConvertible {
  static let typeID = "Project"

  init(from remoteModel: CKRecord) {
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

  func mapProperties(onto remoteModel: inout CKRecord) {
    remoteModel.setValuesForKeys([
      "title": title,
      "details": details,
      "isClosed": isClosed,
      "items": Self.mapValue(for: \.items, input: items),
      "comments": Self.mapValue(for: \.comments, input: comments),
      "owner": Self.mapValue(for: \.owner, input: owner)
    ])
  }
}

extension SharedProject: KeyPathQueryable {
  static let propertyNames: [PartialKeyPath<Self>: String] = [
    \.id: "id",
    \.title: "title",
    \.details: "details",
    \.isClosed: "isClosed",
    \.owner: "owner"
  ]
  
  static func mapValue<I>(for keyPath: KeyPath<Self, I>, input: I) -> Any {
    switch keyPath {
    case \.owner:
      if let input = input as? any CustomStringConvertible {
        return CKRecord.Reference(recordID: .init(recordName: input.description), action: .deleteSelf)
      } else { return input }
    case \.items, \.comments:
      if let input = input as? [any CustomStringConvertible] {
        return input
          .map(\.description)
          .map(CKRecord.ID.init)
          .map { CKRecord.Reference(recordID: $0, action: .none) }
      } else { return input }
    default:
      return input
    }
  }
}
