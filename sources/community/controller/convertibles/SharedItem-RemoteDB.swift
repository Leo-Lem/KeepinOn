//	Created by Leopold Lemmermann on 25.10.22.

import CloudKitService

extension SharedItem: DatabaseObjectConvertible {
  static let typeID = "Item"

  init(from remoteModel: CKRecord) {
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

  func mapProperties(onto remoteModel: inout CKRecord) {
    remoteModel.setValuesForKeys([
      "title": title,
      "details": details,
      "isDone": isDone,
      "project": Self.mapValue(for: \.project, input: project)
    ])
  }
}

extension SharedItem: KeyPathQueryable {
  static let propertyNames: [PartialKeyPath<Self>: String] = [
    \.id: "id",
    \.project: "project",
    \.title: "title",
    \.details: "details",
    \.isDone: "isDone"
  ]
  
  static func mapValue<I>(for keyPath: KeyPath<Self, I>, input: I) -> Any {
    switch keyPath {
    case \.project:
      if let input = input as? any CustomStringConvertible {
        return CKRecord.Reference(recordID: .init(recordName: input.description), action: .deleteSelf)
      } else { return input }
    default:
      return input
    }
  }
}
