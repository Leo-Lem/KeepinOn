//	Created by Leopold Lemmermann on 28.10.22.

import CloudKitService
import Colors

extension User: DatabaseObjectConvertible {
  static let typeID = "User"

  init(from remoteModel: CKRecord) {
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

  func mapProperties(onto remoteModel: inout CKRecord) {
    remoteModel.setValuesForKeys([
      "name": name,
      "colorID": colorID.rawValue,
      "projects": Self.mapValue(for: \.projects, input: projects),
      "comments": Self.mapValue(for: \.comments, input: comments)
    ])
  }
}

extension User: KeyPathQueryable {
  static let propertyNames: [PartialKeyPath<Self>: String] = [
    \.id: "id",
    \.name: "name",
    \.colorID: "colorID"
  ]
  
  static func mapValue<I>(for keyPath: KeyPath<Self, I>, input: I) -> Any {
    switch keyPath {
    case \.projects, \.comments:
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
