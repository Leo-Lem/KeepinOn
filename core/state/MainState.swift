//  Created by Leopold Lemmermann on 24.10.22.

import AwardsService
import CloudKitService
import Concurrency
import CoreDataService
import CoreSpotlightService
import Errors
import Foundation
import MyAuthenticationService
import StoreKitService
import UserNotificationsService

@MainActor final class MainState: ObservableObject {
  let tasks = Tasks()
  
  @Published var authenticationState = AuthenticationState.notAuthenticated
  @Published var hasFullVersion = false
  @Published var sortOrder: Item.SortOrder = .optimized
  @Published var presentation = (page: Page.home, detail: Detail?.none, banner: Banner?.none, alert: Alert?.none)
  @Published var projectLimitReached = false

  let privateDBService: any DatabaseService,
      publicDBService: any DatabaseService,
      indexingService: any IndexingService,
      notificationService: any PushNotificationService,
      authService: any AuthenticationService,
      purchaseService: AnyInAppPurchaseService<PurchaseID>,
      awardsService: any AwardsService
  #if os(iOS)
    let widgetService: WidgetService
  #endif

  init() async {
    privateDBService = await CoreDataService()
    publicDBService = await CloudKitService(container: CKContainer(identifier: Config.id.cloudKit))
    indexingService = CoreSpotlightService(appname: Config.appname)
    awardsService = AwardsServiceImpl()
    purchaseService = await .storekit()
    notificationService = await UserNotificationsService()
    authService = await MyAuthenticationService(server: URL(string: "https://auth.leolem.de")!)

    #if os(iOS)
      widgetService = WidgetServiceImplementation()
      tasks["setWidgetsOnLocalDatabaseEvent"] = privateDBService.handleEventsTask { [weak self] event in
        await self?.setWidgets(on: event)
      }
    #endif

    // setup
    hasFullVersion = purchaseService.isPurchased(with: .fullVersion)
    await setAuthenticationState(for: authService.status)
    await setProjectLimitReached(on: .remote)

    tasks["handlePrivateDatabaseEvent"] = privateDBService.handleEventsTask { [weak self] event in
      await self?.setProjectLimitReached(on: event)
      await self?.setIndex(on: event)
    }
    tasks["setIsPremiumOnPurchaseEvent"] = purchaseService.handleEventsTask { [weak self] event in
      await self?.setIsPremium(on: event)
    }
    tasks["setAuthenticationStateOnAuthEvent"] = authService.handleEventsTask { [weak self] status in
      await self?.setAuthenticationState(for: status)
    }
    tasks["setAuthenticationStateOnPublicDatabaseEvent"] = publicDBService.handleEventsTask { [weak self] event in
      await self?.setAuthenticationState(on: event)
    }
    tasks["showBannerOnAwardsEvent"] = awardsService.handleEventsTask(.high) { [weak self] event in
      self?.showBanner(on: event)
    }

    #if DEBUG
      if CommandLine.arguments.contains("--under-test") {
        await (privateDBService as? CoreDataService)!.deleteAll()
        await (publicDBService as? CloudKitService)!.deleteAll()
        awardsService.resetProgress()
        printError(authService.logout)
      }

      tasks.add(
        privateDBService.handleEventsTask { print("PrivateDBService: \($0)") },
        publicDBService.handleEventsTask { print("PublicDBService: \($0)") },
        purchaseService.handleEventsTask { print("PurchaseService: \($0)") },
        notificationService.handleEventsTask { print("NotificationService: \($0)") },
        authService.handleEventsTask { print("AuthService: \($0)") },
        awardsService.handleEventsTask { print("AwardsService: \($0)") }
      )
    #endif
  }

  #if DEBUG
    static let mock = MainState(mocked: ())
    private init(mocked: Void) {
      privateDBService = .mock
      publicDBService = .mock
      indexingService = .mock
      notificationService = .mock
      authService = .mock
      purchaseService = .mock
      awardsService = AwardsServiceImpl()

      #if os(iOS)
        widgetService = WidgetServiceImplementation()
      #endif
    }
  #endif
}
