//	Created by Leopold Lemmermann on 20.10.22.

import Combine
import CoreSpotlight

final class CSService: IndexingService {
  func updateReference<T: Indexable>(to indexable: T) {
    index.indexSearchableItems([indexable.csSearchableItem])
  }

  func removeReference(with id: UUID) {
    index.deleteSearchableItems(withIdentifiers: [id.uuidString])
  }

  static let activityType = CSSearchableItemActionType,
             activityID = CSSearchableItemActivityIdentifier

  private var index: CSSearchableIndex { .default() }
}
