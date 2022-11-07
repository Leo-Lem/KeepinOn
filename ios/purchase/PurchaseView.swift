//	Created by Leopold Lemmermann on 07.10.22.

import SwiftUI

extension PurchasingView {
  struct PurchaseView: View {
    let purchase: Purchase, makePurchase: (Purchase.ID) -> Void

    var body: some View {
      ScrollView {
        VStack(spacing: 20) {
          Text("IAP_HEADLINE")
            .font(.default(.headline))
            .padding(.top, 10)

          Text("IAP_DESCRIPTION \(purchase.price)")

          Button("IAP_BUY_BUTTON \(purchase.price)") { makePurchase(purchase.id) }
            .buttonStyle(.purchase)
        }
      }
    }
  }
}

// MARK: - (PREVIEWS)

struct ProductView_Previews: PreviewProvider {
  static var previews: some View {
    PurchasingView.PurchaseView(purchase: .example, makePurchase: {_ in})
  }
}
