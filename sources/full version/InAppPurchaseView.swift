// Created by Leopold Lemmermann on 08.12.22.

import AwardsController
import InAppPurchaseUI
import SwiftUI
import Concurrency
import Errors

struct InAppPurchaseView: View {
  let id: PurchaseID
  
  var body: some View {
    InAppPurchaseUI.InAppPurchaseView(id: id, service: controller.service)
      .accessibilityIdentifier("iap-popover")
      .onAppear {
        tasks["notifyAwardsController"] = controller.handleEventsTask(.userInitiated) { [self] event in
          await printError {
            switch event {
            case .unlockedFullVersion: try await self.awardsController.notify(of: .becamePremium)
            }
          }
        }
      }
  }
  
  @EnvironmentObject private var controller: IAPController
  @EnvironmentObject private var awardsController: AwardsController
  
  private let tasks = Tasks()
  
  init(_ id: PurchaseID) { self.id = id }
}
