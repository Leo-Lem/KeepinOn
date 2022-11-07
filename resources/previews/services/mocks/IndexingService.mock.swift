//	Created by Leopold Lemmermann on 20.10.22.

import Foundation

final class MockIndexingService: IndexingService {
  func updateReference<T: Indexable>(to indexable: T) {
    print("Created reference to \(indexable.title)!")
  }

  func removeReference(with id: UUID) {
    print("Removed reference to \(id)!")
  }
}
