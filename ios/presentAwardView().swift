//	Created by Leopold Lemmermann on 28.11.22.

import AwardsService
import SwiftUI

extension PresentAwardViewModifier {
  func presentAwardView<Content: View>(_ content: Content) -> some View {
    content
      .alert(
        "\(displayedAward?.name ?? "???") (\(Text(isUnlocked ? "AWARD_UNLOCKED" : "AWARD_LOCKED")))",
        isPresented: Binding(optional: $displayedAward),
        presenting: displayedAward
      ) { award in
        if award.criterion == .unlock && !isUnlocked {
          Button { isPurchasing = true } label: { Label("UNLOCK_FULL_VERSION", systemImage: "cart") }
            .sheet(isPresented: $isPurchasing) { PurchaseID.fullVersion.view(service: mainState.purchaseService) }

          Button("OK") {}
        }
      } message: { award in
        Text("\(award.description)")
      }
  }
}
