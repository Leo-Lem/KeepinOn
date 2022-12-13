// Created by Leopold Lemmermann on 13.12.22.

import Foundation
import InAppPurchaseService
import AwardsController
import Concurrency

class IAPController: EventDriver, ObservableObject {
  let eventPublisher = Publisher<Event>()
  @Published var fullVersionIsUnlocked: Bool!
  let service: AnyInAppPurchaseService<PurchaseID>
  
  private let tasks = Tasks()
  
  init(service: AnyInAppPurchaseService<PurchaseID>) {
    self.service = service
    self.fullVersionIsUnlocked = getFullVersionIsUnlocked()
    tasks.add(service.handleEventsTask(.background, with: setFullVersionIsUnlocked))
  }
}
