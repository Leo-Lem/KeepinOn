//	Created by Leopold Lemmermann on 07.10.22.

import AwardsService
import Concurrency
import InAppPurchaseService
import LeosMisc
import SwiftUI

struct AwardsView: View {
  var body: some View {
    ScrollView {
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 100))]) {
        ForEach(allAwards) { award in
          Button { displayedAward = award } label: {
            award
              .icon(isUnlocked: isUnlocked(award))
              .aspectRatio(1, contentMode: .fit)
          }
          .presentAward(award, current: $displayedAward)
        }
      }
      .accessibilityLabel("AWARDS_TITLE")
    }
    .task {
      unlockedAwards = service.unlockedAwards

      tasks.add(service.didChange.getTask(.high) { change in
        if case let .unlocked(award) = change { unlockedAwards.insert(award) }
      })
    }
  }

  @EnvironmentObject private var mainState: MainState
  
  @State private var displayedAward: Award?
  @State private var unlockedAwards = Set<Award>()

  private let tasks = Tasks()
}

private extension AwardsView {
  var service: AwardsService { mainState.awardsService }
  var allAwards: [Award] { service.allAwards }

  func isUnlocked(_ award: Award) -> Bool { unlockedAwards.contains(award) }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct AwardsView_Previews: PreviewProvider {
    static var previews: some View {
      AwardsView()
        .configureForPreviews()
    }
  }
#endif
