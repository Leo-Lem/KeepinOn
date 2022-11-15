//	Created by Leopold Lemmermann on 10.11.22.

import CloudKit
import CloudKitService

final class CKService: CloudKitService {
  static let containerID = "iCloud.LeoLem.KeepinOn"

  init() async {
    await super.init(CKContainer(identifier: Self.containerID), scope: .public)
  }
}

typealias CKServiceError = CloudKitError
//extension CKContainer: CloudKitContainer {}
//extension CKDatabase: CloudKitDatabase {}
