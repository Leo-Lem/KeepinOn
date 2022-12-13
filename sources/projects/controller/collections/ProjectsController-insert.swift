// Created by Leopold Lemmermann on 13.12.22.

import DatabaseService

extension ProjectsController {
  func insert<T: DatabaseObjectConvertible>(_ convertible: T, into convertibles: inout [T]) {
    if let index = convertibles.index(ofElementWith: convertible.id) {
      convertibles[index] = convertible
    } else {
      convertibles.append(convertible)
    }
  }
}
