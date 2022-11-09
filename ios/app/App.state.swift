//  Created by Leopold Lemmermann on 24.10.22.

import Combine
import Foundation

struct Settings: Codable {
  var itemSortOrder: Item.SortOrder = .optimized
}

final class AppState: ObservableObject {
  let didChange = ObservableObjectPublisher()

  let routingService: KORoutingService,
      privDBService: PrivDBService,
      publicDatabaseService: PublicDatabaseService,
      keyValueService: KeyValueService,
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
    privDBService: PrivDBService = CDService(),
    publicDatabaseService: PublicDatabaseService? = nil,
    keyValueService: KeyValueService = UDService(),
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

    if let service = publicDatabaseService {
      self.publicDatabaseService = service
    } else {
      self.publicDatabaseService = await CKService()
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
        publicDatabaseService: self.publicDatabaseService
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
      self.privDBService.didChange.getTask(with: updateIndices),
      self.privDBService.didChange.getTask(with: updateWidgets)
    )
  }

  #if DEBUG
    init(mocked: Void) {
      privDBService = MockPrivDBService()
      publicDatabaseService = MockPublicDatabaseService()
      keyValueService = MockKeyValueService()
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
    } catch let error as PublicDatabaseError {
      if case let .userRelevant(reason) = error {
        routingService.route(to: .alert(Alert.error(reason.localizedDescription)))
      }

      throw error
    } catch let error as AuthError {
      routingService.route(to: .alert(Alert.error(error.localizedDescription)))

      throw error
    }
  }
}

private extension AppState {
  func updateIndices(on change: PrivDBChange) {
    switch change {
    case let .inserted(convertible):
      if let indexable = convertible as? Indexable {
        indexingService.updateReference(to: indexable)
      }
    case let .deleted(id, _):
      indexingService.removeReference(with: id)
    default: break
    }
  }

  func updateWidgets(on change: PrivDBChange) {
    printError {
      widgetService.provide(
        try privDBService
          .fetch(Query<Item>(\.isDone, .equal, false))
          .compactMap { item in item.attachProject(privDBService) }
      )
    }
  }
}
