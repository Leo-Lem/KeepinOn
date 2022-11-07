//	Created by Leopold Lemmermann on 07.10.22.

import Foundation

extension AwardsView {
  @MainActor final class ViewModel: KeepinOn.ViewModel {
    override init(appState: AppState) {
      super.init(appState: appState)

      tasks.add(awardService.didChange.getTask { [weak self] _ in
        self?.update()
      })
    }
  }
}

extension AwardsView.ViewModel {
  func showAlert(for award: Award) {
    routingService.route(
      to: .alert(Alert.award(award, unlocked: isUnlocked(award)))
    )
  }

  func isUnlocked(_ award: Award) -> Bool {
    awardService.isUnlocked(award)
  }

  var allAwards: [Award] {
    awardService.allAwards
  }
}
