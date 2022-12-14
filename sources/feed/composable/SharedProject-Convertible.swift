//	Created by Leopold Lemmermann on 25.10.22.

import CloudKitService
import Colors

extension SharedProject: DatabaseObjectConvertible {
  static let typeID = "Project"

  init(from remoteModel: CKRecord) {
    let id = ID(uuidString: remoteModel.recordID.recordName) ?? ID()
    let owner = remoteModel["owner"] as? CKRecord.Reference

    self.init(
      id: id,
      title: remoteModel["title"] as? String ?? "",
      details: remoteModel["details"] as? String ?? "",
      isClosed: remoteModel["isClosed"] as? Bool ?? false,
      colorID: ColorID(rawValue: remoteModel["colorID"] as? String ?? "") ?? .darkBlue,
      owner: (owner?.recordID.recordName) ?? User.ID()
    )
    
    if owner == nil { debugPrint("Faulty Owner reference in Project with id \(id).") }
  }

  func mapProperties(onto remoteModel: inout CKRecord) {
    remoteModel.setValuesForKeys([
      "title": title,
      "details": details,
      "isClosed": isClosed,
      "colorID": colorID.rawValue,
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
    default:
      return input
    }
  }
}
