//	Created by Leopold Lemmermann on 05.12.22.

import DatabaseService

extension MainState {
  @MainActor func fetch<T: DatabaseObjectConvertible>(with id: T.ID, fromPrivate: Bool = true) async throws -> T? {
    fromPrivate ?
      try await privateDBService.fetch(with: id) :
      try await publicDBService.fetch(with: id)
  }
  
  @MainActor @inlinable func insert<T: DatabaseObjectConvertible>(_ convertible: T, into convertibles: inout [T]) {
    var optional: [T]? = convertibles
    insert(convertible, into: &optional)
    convertibles = optional ?? []
    
  }

  @MainActor @inlinable func remove<T: DatabaseObjectConvertible>(with id: T.ID, from convertibles: inout [T]) {
    var optional: [T]? = convertibles
    remove(with: id, from: &optional)
    convertibles = optional ?? []
  }

  @MainActor func insert<T: DatabaseObjectConvertible>(_ convertible: T, into convertibles: inout [T]?) {
    if let index = convertibles?.index(ofElementWith: convertible.id) {
      convertibles?[index] = convertible
    } else {
      convertibles?.append(convertible)
    }
  }

  @MainActor func remove<T: DatabaseObjectConvertible>(with id: T.ID, from convertibles: inout [T]?) {
    if let index = convertibles?.index(ofElementWith: id) {
      convertibles?.remove(at: index)
    }
  }
}
