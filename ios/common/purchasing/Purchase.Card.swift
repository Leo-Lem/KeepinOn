//	Created by Leopold Lemmermann on 07.10.22.

import SwiftUI

extension Purchase {
  func card(makePurchase: @escaping (Purchase.ID) -> Void) -> some View {
    Card(self, makePurchase: makePurchase)
  }
  
  struct Card: View {
    let purchase: Purchase,
        makePurchase: (Purchase.ID) -> Void

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
    
    init(
      _ purchase: Purchase,
      makePurchase: @escaping (Purchase.ID) -> Void
    ) {
      self.purchase = purchase
      self.makePurchase = makePurchase
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ProductView_Previews: PreviewProvider {
  static var previews: some View {
    Purchase.Card(.example) { _ in }
  }
}
#endif
