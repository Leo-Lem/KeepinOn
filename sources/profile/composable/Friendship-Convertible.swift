//  Created by Leopold Lemmermann on 28.10.22.

import CloudKitService

extension Friendship: DatabaseObjectConvertible {
  static let typeID = "Friendship"

  init(from remoteModel: CKRecord) {
    self.init(
      remoteModel["sender"] as? String ?? "",
      remoteModel["receiver"] as? String ?? "",
      accepted: remoteModel["accepted"] as? Bool ?? false
    )
  }

  func mapProperties(onto remoteModel: inout CKRecord) {
    remoteModel.setValuesForKeys([
      "sender": sender,
      "receiver": receiver,
      "accepted": accepted
    ])
  }
}

extension Friendship: KeyPathQueryable {
  static let propertyNames: [PartialKeyPath<Self>: String] = [
    \.id: "id",
    \.sender: "sender",
    \.receiver: "receiver",
    \.accepted: "accepted"
  ]
}
