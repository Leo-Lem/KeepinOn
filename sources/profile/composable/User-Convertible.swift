//	Created by Leopold Lemmermann on 28.10.22.

import CloudKitService
import Colors

extension User: DatabaseObjectConvertible {
  static let typeID = "User"

  init(from remoteModel: CKRecord) {
    self.init(
      id: remoteModel.recordID.recordName,
      name: remoteModel["name"] as? String ?? "",
      colorID: ColorID(rawValue: remoteModel["colorID"] as? String ?? "") ?? .darkBlue,
      avatarID: AvatarID(from: remoteModel["avatarID"] as? String ?? "") ?? .person
    )
  }

  func mapProperties(onto remoteModel: inout CKRecord) {
    remoteModel.setValuesForKeys([
      "name": name,
      "colorID": colorID.rawValue,
      "avatarID": avatarID.systemName
    ])
  }
}

extension User: KeyPathQueryable {
  static let propertyNames: [PartialKeyPath<Self>: String] = [
    \.id: "id",
    \.name: "name",
    \.colorID: "colorID",
    \.avatarID: "avatarID"
  ]
}
