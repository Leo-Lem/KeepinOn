//	Created by Leopold Lemmermann on 27.11.22.

import AwardsService

extension AwardsServiceImpl {
  func isUnlocked(_ award: Award, progress: Award.Progress) -> Bool {
    switch award.criterion {
    case .items:
      return progress.itemsAdded >= award.value
    case .complete:
      return progress.itemsCompleted >= award.value
    case .chat:
      return progress.commentsPosted >= award.value
    case .unlock:
      return progress.fullVersionIsUnlocked
    default:
      print("unknown award criterion: \(award.criterion)")
      return false
    }
  }
}
