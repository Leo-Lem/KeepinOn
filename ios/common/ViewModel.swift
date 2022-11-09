//	Created by Leopold Lemmermann on 27.10.22.

import Combine

@MainActor
class ViewModel: ObservableObject {
  let appState: AppState

  var routingService: KORoutingService { appState.routingService }
  var privDBService: PrivDBService { appState.privDBService }
  var publicDatabaseService: PublicDatabaseService { appState.publicDatabaseService }
  var keyValuePersistenceService: KeyValueService { appState.keyValueService }
  var indexingService: IndexingService { appState.indexingService }
  var notificationService: NotificationService { appState.notificationService }
  var authService: AuthService { appState.authService }
  var purchaseService: PurchaseService { appState.purchaseService }
  var awardService: AwardsService { appState.awardService }
  var hapticsService: HapticsService? { appState.hapticsService }

  private(set) var tasks = Tasks()

  init(appState: AppState) {
    self.appState = appState

    tasks.add(for: "stateHook", self.appState.objectWillChange.getTask(with: update))
  }

  func update() {
    objectWillChange.send()
  }
}
