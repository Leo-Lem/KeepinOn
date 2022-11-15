//	Created by Leopold Lemmermann on 27.10.22.

import Combine
import Concurrency

@MainActor
class ViewModel: ObservableObject {
  let appState: AppState

  var routingService: KORoutingService { appState.routingService }
  var privDBService: LocalDBService { appState.privDBService }
  var remoteDBService: RemoteDBService { appState.remoteDBService }
  var keyValuePersistenceService: KVSService { appState.keyValueService }
  var indexingService: IndexingService { appState.indexingService }
  var notificationService: NotificationService { appState.notificationService }
  var authService: AuthService { appState.authService }
  var purchaseService: PurchaseService { appState.purchaseService }
  var awardService: AwardsService { appState.awardService }
  var hapticsService: HapticsService? { appState.hapticsService }

  private(set) var tasks = Tasks()

  init(appState: AppState) {
    self.appState = appState

    tasks["propagateStateUpdates"] = self.appState.objectWillChange.getTask(.high, operation: update)
  }

  func update() {
    objectWillChange.send()
  }
}
