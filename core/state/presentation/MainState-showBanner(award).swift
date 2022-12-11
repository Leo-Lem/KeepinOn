//	Created by Leopold Lemmermann on 04.12.22.

import AwardsService

extension MainState {
  @MainActor func showBanner(on event: AwardsEvent) {
    if case let .unlocked(award) = event { presentation.banner = .awardEarned(award) }
  }
}
