//	Created by Leopold Lemmermann on 05.10.22.

import Foundation

extension PrivateDatabaseService {
  func createSampleData() {
    do {
      for _ in 1 ... 5 {
        try insert(Project.example)
      }
    } catch { print(error.localizedDescription) }
  }

  func deleteAll() {
    deleteAll(Project.self)
    deleteAll(Item.self)
  }

  func deleteAll<T: PrivateModelConvertible>(_: T.Type) {
    do {
      let result = try fetch(Query<T>(true))
      try result.forEach {
        if let id = ($0 as? any Identifiable)?.id as? UUID {
          try delete(with: id)
        }
      }
    } catch { print(error.localizedDescription) }
  }
}
