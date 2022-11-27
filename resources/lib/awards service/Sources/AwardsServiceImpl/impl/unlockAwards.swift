//	Created by Leopold Lemmermann on 27.11.22.

import AwardsService

extension AwardsServiceImpl {
  func unlockAwards() {
    for award in allAwards where isUnlocked(award, progress: self.progress) {
      unlockedAwards.insert(award)
    }
  }
}
