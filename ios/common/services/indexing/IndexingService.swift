//	Created by Leopold Lemmermann on 20.10.22.

import Foundation

protocol IndexingService {
  func updateReference<T: Indexable>(to indexable: T)
  func removeReference(with id: UUID)
}
