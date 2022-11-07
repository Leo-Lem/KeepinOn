//  Created by Leopold Lemmermann on 24.10.22.

import Combine
import Foundation

final class AppState: ObservableObject {
  let didChange = ObservableObjectPublisher()

  let routingService: RoutingService,
      privateDatabaseService: PrivateDatabaseService,
      publicDatabaseService: PublicDatabaseService,
      keyValueService: KeyValueService,
      indexingService: IndexingService,
      notificationService: NotificationService,
      authService: AuthService,
      purchaseService: PurchaseService,
      awardService: AwardsService,
      hapticsService: HapticsService?

  @Published var settings = Settings()

  init(
    routingService: RoutingService? = nil,
    privateDatabaseService: PrivateDatabaseService? = nil,
    publicDatabaseService: PublicDatabaseService? = nil,
    keyValueService: KeyValueService? = nil,
    indexingService: IndexingService? = nil,
    notificationService: NotificationService? = nil,
    authService: AuthService? = nil,
    purchaseService: PurchaseService? = nil,
    awardService: AwardsService? = nil,
    hapticsService: HapticsService? = nil
  ) async {
    self.keyValueService = keyValueService ?? UDService()
    self.indexingService = indexingService ?? CSService()
    self.hapticsService = hapticsService ?? (try? CHService())

    self.privateDatabaseService = privateDatabaseService ?? CDService(indexingService: self.indexingService)
    self.routingService = routingService ?? KORoutingService(keyValueService: self.keyValueService)

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
  }

  #if DEBUG
    init(mocked: Void) {
      privateDatabaseService = MockPrivateDatabaseService()
      publicDatabaseService = MockPublicDatabaseService()
      keyValueService = MockKeyValueService()
      indexingService = MockIndexingService()
      notificationService = MockNotificationService()
      authService = MockAuthService()
      purchaseService = MockPurchaseService()
      awardService = MockAwardsService()
      hapticsService = nil
      routingService = MockRoutingService(keyValueService: keyValueService)
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

struct Settings: Codable {
  var itemSortOrder: Item.SortOrder = .optimized
}
