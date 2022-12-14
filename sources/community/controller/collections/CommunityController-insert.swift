//	Created by Leopold Lemmermann on 05.12.22.

import DatabaseService

extension CommunityController {
  func insert<T: DatabaseObjectConvertible>(_ convertible: T, into convertibles: inout [T]?) {
    if let index = convertibles?.index(ofElementWith: convertible.id) {
      convertibles?[index] = convertible
    } else {
      convertibles?.append(convertible)
    }
  }
}
