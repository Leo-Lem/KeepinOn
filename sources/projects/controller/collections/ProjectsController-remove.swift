// Created by Leopold Lemmermann on 13.12.22.

import DatabaseService

extension ProjectsController {
  func remove<T: DatabaseObjectConvertible>(with id: T.ID, from convertibles: inout [T]) {
    if let index = convertibles.index(ofElementWith: id) {
      convertibles.remove(at: index)
    }
  }
}
