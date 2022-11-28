//	Created by Leopold Lemmermann on 28.11.22.

import AwardsService
import SwiftUI

extension PresentAwardViewModifier {
  func presentAwardView<Content: View>(_ content: Content) -> some View {
    content
      .popover(item: $displayedAward) { award in
        HStack {
          VStack {
            Text(isUnlocked ? "AWARD_UNLOCKED \(award.name)" : "AWARD_LOCKED").bold()
            Text(award.description)
          }
        }
        
        HStack {
          if award.criterion == .unlock && !isUnlocked {
            Button { isPurchasing = true } label: { Label("UNLOCK_FULL_VERSION", systemImage: "cart") }
          }
        }
      }
  }
}
