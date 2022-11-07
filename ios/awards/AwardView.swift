//  Created by Leopold Lemmermann on 04.03.22.

import SwiftUI

extension AwardsView {
  struct AwardView: View {
    let award: Award, unlocked: Bool

    var body: some View {
      Image(systemName: award.image)
        .resizable()
        .scaledToFit()
        .padding()
        .frame(width: 100, height: 100)
        .foregroundColor(unlocked ? award.color : .secondary.opacity(0.5))
        .accessibilityLabel(unlocked ? "UNLOCKED \(award.name)" : "LOCKED \(award.name)")
        .accessibilityHint(award.description)
    }
  }
}

// MARK: - (Previews)

struct AwardView_Previews: PreviewProvider {
  static var previews: some View {
    AwardsView.AwardView(award: .example, unlocked: false)
      .previewDisplayName("Locked")

    AwardsView.AwardView(award: .example, unlocked: true)
      .previewDisplayName("Unlocked")
  }
}
