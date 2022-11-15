//	Created by Leopold Lemmermann on 30.10.22.

import CloudKit

extension Credential: RemoteConvertible {
  typealias RemoteModel = CKRecord
  static let typeID = "Credential"

  init(from remoteModel: RemoteModel) {
    self.init(
      id: remoteModel.recordID.recordName,
      pin: remoteModel["pin"] as? String
    )
  }
  
  func mapProperties(onto remoteModel: RemoteModel) -> RemoteModel {
    remoteModel["pin"] = pin
    
    return remoteModel
  }
}
