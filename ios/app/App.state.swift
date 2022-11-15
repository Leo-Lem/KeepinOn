//  Created by Leopold Lemmermann on 24.10.22.

import Combine
import Concurrency
import Errors
import Foundation

struct Settings: Codable {
  var itemSortOrder: Item.SortOrder = .optimized
}

final class AppState: ObservableObject {
  let didChange = ObservableObjectPublisher()

  let routingService: KORoutingService,
      privDBService: LocalDBService,
      remoteDBService: RemoteDBService,
      keyValueService: KVSService,
      indexingService: IndexingService,
      notificationService: NotificationService,
      authService: AuthService,
      purchaseService: PurchaseService,
      awardService: AwardsService,
      hapticsService: HapticsService?,
      widgetService: WidgetService

  @Published var settings = Settings()

  private var tasks = Tasks()

  init(
    routingService: KORoutingService = KORoutingService(),
    privDBService: LocalDBService = CDService(),
    remoteDBService: RemoteDBService? = nil,
    keyValueService: KVSService = UDService(),
    indexingService: IndexingService = CSService(),
    notificationService: NotificationService? = nil,
    authService: AuthService? = nil,
    purchaseService: PurchaseService? = nil,
    awardService: AwardsService? = nil,
    hapticsService: HapticsService? = (try? CHService()),
    widgetService: WidgetService = KOWidgetService()
  ) async {
    self.keyValueService = keyValueService
    self.indexingService = indexingService
    self.hapticsService = hapticsService
    self.privDBService = privDBService
    self.widgetService = widgetService
    self.routingService = routingService

    if let service = remoteDBService {
      self.remoteDBService = service
    } else {
      self.remoteDBService = await CKService()
    }

    if let service = notificationService {
      self.notificationService = service
    } else {
      self.notificationService = await UNService()
    }

    if let service = purchaseService {
      self.purchaseService = service
    } else {
      self.purchaseService = await SKService()
    }

    if let service = authService {
      self.authService = service
    } else {
      self.authService = await KOAuthService(
        keyValueService: self.keyValueService,
        remoteDBService: self.remoteDBService
      )
    }

    self.awardService = awardService ?? KOAwardsService(
      authService: self.authService,
      keyValueService: self.keyValueService
    )

    printError {
      settings ?= try self.keyValueService.fetchObject(for: "settings")
    }

    tasks.add(
      self.privDBService.didChange.getTask(operation: updateIndices),
      self.privDBService.didChange.getTask(operation: updateWidgets)
    )
  }

  #if DEBUG
    init(mocked: Void) {
      privDBService = MockLocalDBService()
      remoteDBService = MockRemoteDBService()
      keyValueService = MockKVSService()
      indexingService = MockIndexingService()
      notificationService = MockNotificationService()
      authService = MockAuthService()
      purchaseService = MockPurchaseService()
      awardService = MockAwardsService()
      hapticsService = nil
      routingService = KORoutingService()
      widgetService = KOWidgetService()
    }
  #endif
}

extension AppState {
  func showErrorAlert(_ action: () async throws -> Void) async rethrows {
    do {
      try await action()
    } catch let error as CKServiceError {
      switch error {
      case let .fetching(reason, type: _),
           let .publishing(reason, type: _),
           let .unpublishing(reason, type: _):
        routingService.route(to: .alert(Alert.error(reason.localizedDescription)))
      default: break
      }

      throw error
    } catch let error as AuthError {
      routingService.route(to: .alert(Alert.error(error.localizedDescription)))

      throw error
    }
  }
}

private extension AppState {
  func updateIndices(on change: LocalDBChange) {
    switch change {
    case let .inserted(convertible):
      if let indexable = convertible as? any Indexable {
        indexingService.updateReference(to: indexable)
      }
    case let .deleted(id, _):
      indexingService.removeReference(with: id.description)
    default: break
    }
  }

  func updateWidgets(on change: LocalDBChange) {
    printError {
      widgetService.provide(
        try privDBService
          .fetch(Query<Item>(\.isDone, .equal, false))
          .compactMap { item in item.attachProject(privDBService) }
      )
    }
  }
}
