//  Created by Leopold Lemmermann on 04.03.22.

import AwardsController
import SwiftUI

extension Award {
  func icon(isUnlocked: Bool) -> some View {
    Icon(self, isUnlocked: isUnlocked)
  }

  struct Icon: View {
    let award: Award,
        isUnlocked: Bool

    var body: some View {
      Image(systemName: award.image)
        .resizable()
        .scaledToFit()
        .padding()
        .foregroundColor(isUnlocked ? award.colorID.color : .secondary.opacity(0.5))
        .accessibilityLabel(
          Text(isUnlocked ? "A11Y_AWARD_UNLOCKED" : "A11Y_AWARD_LOCKED")
        )
        .accessibilityValue(award.name)
        .accessibilityIdentifier(award.name)
        .if(isUnlocked) { $0.shadow(color: award.colorID.color.opacity(0.8), radius: 5) }
    }

    init(_ award: Award, isUnlocked: Bool) {
      self.award = award
      self.isUnlocked = isUnlocked
    }
  }
}

// MARK: - (Previews)

#if DEBUG
  struct AwardView_Previews: PreviewProvider {
    static var previews: some View {
      Award.Icon(.example, isUnlocked: false)
        .previewDisplayName("Locked")

      Award.Icon(.example, isUnlocked: true)
        .previewDisplayName("Unlocked")
    }
  }
#endif
