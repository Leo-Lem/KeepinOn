//	Created by Leopold Lemmermann on 27.10.22.

import Foundation
import Concurrency
import HapticsService
import IndexingService
import KeyValueStorageService
import PushNotificationService
import AuthenticationService
import StoreKitService
import LocalDatabaseService
import RemoteDatabaseService
import AwardsService

@MainActor
class ViewModel: ObservableObject {
  let mainState: MainState

  var localDBService: LocalDatabaseService { mainState.localDBService }
  var remoteDBService: RemoteDatabaseService { mainState.remoteDBService }
  var indexingService: IndexingService { mainState.indexingService }
  var notificationService: PushNotificationService { mainState.notificationService }
  var authService: AuthenticationService { mainState.authService }
  var purchaseService: AnyInAppPurchaseService<PurchaseID> { mainState.purchaseService }
  var awardsService: AwardsService { mainState.awardsService }
  var hapticsService: HapticsService? { mainState.hapticsService }

  private(set) var tasks = Tasks()

  init(mainState: MainState) {
    self.mainState = mainState

    tasks["mainStateUpdate"] = self.mainState.objectWillChange.getTask(.high, operation: update)
  }

  func update() { objectWillChange.send() }
}
