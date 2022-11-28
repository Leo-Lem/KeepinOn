//  Created by Leopold Lemmermann on 24.10.22.

import AuthenticationService
import AwardsService
import AwardsServiceImpl
import CloudKit
import CloudKitService
import Combine
import Concurrency
import CoreHapticsService
import CoreSpotlightService
import Errors
import Foundation
import HapticsService
import InAppPurchaseService
import IndexingService
import LeosMisc
import LocalDatabaseService
import MyAuthenticationService
import PushNotificationService
import RemoteDatabaseService
import StoreKitService
import UserDefaultsService
import UserNotificationsService

final class MainState: ObservableObject {
  let didChange = PassthroughSubject<Change, Never>()
  enum Change: Equatable {
    case page(Page),
         sheet(Sheet),
         banner(Banner),
         alert(Alert),
         user(User?),
         isPremium(Bool)
  }

  @Published private(set) var user: User? {
    didSet { didChange.send(.user(user)) }
  }

  @Published private(set) var isPremium = false {
    didSet { didChange.send(.isPremium(isPremium)) }
  }

  let localDBService: LocalDatabaseService,
      remoteDBService: RemoteDatabaseService,
      indexingService: IndexingService,
      notificationService: PushNotificationService,
      authService: AuthenticationService,
      purchaseService: AnyInAppPurchaseService<PurchaseID>,
      awardsService: AwardsService,
      widgetService: WidgetService,
      hapticsService: HapticsService?

  private let tasks = Tasks()

  init() async {
    localDBService = CDService()
    remoteDBService = await CloudKitService(CKContainer(identifier: Config.id.cloudKit))
    indexingService = CoreSpotlightService(appname: Config.appname)
    awardsService = AwardsServiceImpl()
    purchaseService = await .storekit()
    notificationService = await UserNotificationsService()
    authService = await MyAuthenticationService(url: URL(string: "https://github-repo-j3opzjp32q-lz.a.run.app")!)
    hapticsService = CoreHapticsService()
    widgetService = WidgetServiceImplementation()

    // setup
    isPremium = purchaseService.isPurchased(id: .fullVersion)
    await updateUser(authService.status)

    // reactive
    tasks.add(
      localDBService.didChange.getTask(operation: updateIndices),
      localDBService.didChange.getTask(operation: updateWidgets),
      authService.didChange.getTask(.high, operation: updateUser),
      remoteDBService.didChange.getTask(.high, operation: updateUser),
      purchaseService.didChange.getTask(.high, operation: updateIsPremium),
      awardsService.didChange.getTask(.high, operation: showBanner)
    )
    
    #if DEBUG
    if CommandLine.arguments.contains("under-test") {
      localDBService.deleteAll()
      await remoteDBService.unpublishAll()
      awardsService.resetProgress()
      printError(authService.logout)
    }
    #endif
  }

  #if DEBUG
    static let mock = MainState(mocked: ())
    private init(mocked: Void) {
      localDBService = .mock
      remoteDBService = .mock
      indexingService = .mock
      notificationService = .mock
      authService = .mock
      purchaseService = .mock
      awardsService = AwardsServiceImpl()
      widgetService = WidgetServiceImplementation()
      hapticsService = nil
    }
  #endif
}

extension MainState {
  func displayError<T>(_ throwing: () throws -> T) rethrows -> T {
    do {
      return try throwing()
    } catch let error as RemoteDatabaseError {
      if let display = error.display {
        didChange.send(.alert(.remoteDBError(display)))
      } else { print(error) }

      throw error
    }
  }

  @_disfavoredOverload
  func displayError<T>(_ throwing: () async throws -> T) async rethrows -> T {
    do {
      return try await throwing()
    } catch let error as RemoteDatabaseError {
      if let display = error.display {
        didChange.send(.alert(.remoteDBError(display)))
      } else { print(error) }

      throw error
    }
  }
}

// updates
private extension MainState {
  func showBanner(on change: AwardsChange) {
    if case let .unlocked(award) = change {
      didChange.send(.banner(.awardEarned(award)))
    }
  }

  func updateIndices(on change: LocalDatabaseChange) async {
    await printError {
      switch change {
      case let .inserted(convertible):
        if let indexable = convertible as? any Indexable {
          try await indexingService.updateReference(to: indexable)
        }

      case let .deleted(id, _):
        try await indexingService.removeReference(with: id.description)

      default: break
      }
    }
  }

  func updateWidgets(on change: LocalDatabaseChange) {
    printError {
      widgetService.provide(
        try localDBService
          .fetch(Query<Item>(\.isDone, .equal, false))
          .compactMap { item in
            printError {
              (try localDBService.fetch(with: item.project) as Project?)
                .flatMap { Item.WithProject(item, project: $0) }
            }
          }
      )
    }
  }

  @MainActor
  func updateUser(_ status: AuthenticationStatus) async {
    await printError {
      switch status {
      case .notAuthenticated:
        user = nil

      case let .authenticated(id):
        if let user: User = try await remoteDBService.fetch(with: id) {
          self.user = user
        } else {
          user = try await remoteDBService.publish(User(id: id))
        }
      }
    }
  }

  @MainActor
  func updateUser(on change: RemoteDatabaseChange) async {
    switch change {
    case let .published(convertible):
      if let user = convertible as? User {
        self.user = user
      }

    case let .unpublished(id, _):
      if id.description == user?.id { user = nil }

    case let .status(status) where status != .unavailable: await updateUser(authService.status)
    case .remote: await updateUser(authService.status)
    default: break
    }
  }

  @MainActor
  func updateIsPremium(_ change: PurchaseChange<PurchaseID>) {
    switch change {
    case let .purchased(purchase):
      if case .fullVersion = purchase.id {
        isPremium = true
        Task { try await awardsService.notify(of: .unlockedFullVersion) }
      }

    default:
      isPremium = purchaseService.isPurchased(id: .fullVersion)
    }
  }
}
