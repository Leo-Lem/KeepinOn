//	Created by Leopold Lemmermann on 05.12.22.

import DatabaseService

extension CommunityController {
  func remove<T: DatabaseObjectConvertible>(with id: T.ID, from convertibles: inout [T]?) {
    if let index = convertibles?.index(ofElementWith: id) {
      convertibles?.remove(at: index)
    }
  }
}
