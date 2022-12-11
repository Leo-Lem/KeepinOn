// Created by Leopold Lemmermann on 08.12.22.

import InAppPurchaseUI
import SwiftUI

struct InAppPurchaseView: View {
  let id: PurchaseID
  
  var body: some View {
    InAppPurchaseUI.InAppPurchaseView(id: id, service: mainState.purchaseService)
  }
  
  @EnvironmentObject private var mainState: MainState
  
  init(_ id: PurchaseID) { self.id = id }
}
