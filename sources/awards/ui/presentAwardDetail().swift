//	Created by Leopold Lemmermann on 28.11.22.

import AwardsController
import SwiftUI

extension View {
  func presentAwardDetails(
    _ award: Award,
    isUnlocked: Bool,
    isPresented: Binding<Bool>,
    isPurchasing: Binding<Bool>
  ) -> some View {
    modifier(AwardDetailPresentation(
      isPresented: isPresented,
      isPurchasing: isPurchasing,
      award: award,
      isUnlocked: isUnlocked
    ))
  }
}

struct AwardDetailPresentation: ViewModifier {
  @Binding var isPresented: Bool
  @Binding var isPurchasing: Bool
  let award: Award, isUnlocked: Bool

  func body(content: Content) -> some View {
    content
    #if os(iOS)
    .alert(
      "\(award.name) (\(Text(isUnlocked ? "AWARD_UNLOCKED" : "AWARD_LOCKED")))",
      isPresented: $isPresented,
      presenting: award
    ) { award in
      if award.criterion == .unlock && !isUnlocked {
        Button { isPurchasing = true } label: {
          Label(String(localized: "UNLOCK_FULL_VERSION"), systemImage: "cart")
        }

        Button("OK") {}
      }
    } message: { award in
      Text("\(award.description)")
    }
    #elseif os(macOS)
    .popover(isPresented: $isPresented) {
      VStack {
        Text(isUnlocked ? "AWARD_UNLOCKED \(award.name)" : "AWARD_LOCKED").bold()
        Text(award.description)

        HStack {
          if award.criterion == .unlock && !isUnlocked {
            Button { isPurchasing = true } label: {
              Label("UNLOCK_FULL_VERSION", systemImage: "cart")
            }
          }
        }
      }
      .padding()
    }
    #endif
  }
}
