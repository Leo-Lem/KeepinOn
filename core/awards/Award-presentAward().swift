//	Created by Leopold Lemmermann on 28.11.22.

import SwiftUI
import AwardsService

extension View {
  func presentAward(_ award: Award, current displayedAward: Binding<Award?>) -> some View {
    modifier(PresentAwardViewModifier(award, displayedAward: displayedAward))
  }
}

struct PresentAwardViewModifier: ViewModifier {
  @Binding var displayedAward: Award?
  let award: Award

  @EnvironmentObject var mainState: MainState
  @State var isPurchasing = false
  
  var isUnlocked: Bool { mainState.awardsService.unlockedAwards.contains(award) }
  
  init(_ award: Award, displayedAward: Binding<Award?>) {
    self.award = award
    _displayedAward = displayedAward
  }
  
  init(displayedAward: Binding<Award?>, award: Award, isPurchasing: Bool = false) {
    _displayedAward = displayedAward
    self.award = award
    self.isPurchasing = isPurchasing
  }

  func body(content: Content) -> some View { presentAwardView(content) }
}
