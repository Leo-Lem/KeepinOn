//	Created by Leopold Lemmermann on 29.11.22.

import AwardsController
import SwiftUI

struct AwardsView: View {
  var body: some View {
    ScrollView {
      LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 100, maximum: 150)), count: 1)) {
        ForEach(allAwards) { award in
          let isUnlocked = isUnlocked(award)
          Button { displayedAward = award } label: {
            award
              .icon(isUnlocked: isUnlocked)
              .aspectRatio(1, contentMode: .fill)
          }
          .presentAwardDetails(
            award, isUnlocked: isUnlocked,
            isPresented: Binding { displayedAward == award } set: { newValue in
              displayedAward = newValue ? award : nil
            },
            isPurchasing: $isPurchasing
          )
        }
      }
    }
    .buttonStyle(.borderless)
    .popover(isPresented: $isPurchasing) { InAppPurchaseView(.fullVersion) }
    .navigationTitle("AWARDS_TITLE")
    .accessibilityElement(children: .contain)
    .accessibilityLabel("AWARDS_TITLE")
  }

  @State private var isPurchasing = false
  @State var displayedAward: Award?

  @EnvironmentObject private var controller: AwardsController

  var allAwards: [Award] { controller.allAwards }
  func isUnlocked(_ award: Award) -> Bool { controller.unlockedAwards.contains(award) }
}
