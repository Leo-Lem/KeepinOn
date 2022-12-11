//	Created by Leopold Lemmermann on 29.11.22.

import AwardsUI

struct AwardsView: View {
  var body: some View {
    AwardsUI.AwardsView(service: mainState.awardsService, isPurchasing: $isPurchasing)
      .buttonStyle(.borderless)
      .popover(isPresented: $isPurchasing) { InAppPurchaseView(.fullVersion) }
      .navigationTitle("AWARDS_TITLE")
      .accessibilityElement(children: .contain)
      .accessibilityLabel("AWARDS_TITLE")
  }
  
  @State private var isPurchasing = false
  
  @EnvironmentObject private var mainState: MainState
}
