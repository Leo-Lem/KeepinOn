// Created by Leopold Lemmermann on 19.12.22.

import ComposableArchitecture

extension DependencyValues {
  var privateDatabaseService: any DatabaseService {
    get { self[PrivateDatabaseServiceKey.self] }
    set { self[PrivateDatabaseServiceKey.self] = newValue }
  }
  
  var indexingService: any IndexingService {
    get { self[IndexingServiceKey.self] }
    set { self[IndexingServiceKey.self] = newValue }
  }
  
  var publicDatabaseService: any DatabaseService {
    get { self[PublicDatabaseServiceKey.self] }
    set { self[PublicDatabaseServiceKey.self] = newValue }
  }
  
  var authenticationService: any AuthenticationService {
    get { self[AuthenticationServiceKey.self] }
    set { self[AuthenticationServiceKey.self] = newValue }
  }

  var pushNotificationService: any PushNotificationService {
    get { self[NotificationServiceKey.self] }
    set { self[NotificationServiceKey.self] = newValue }
  }
  
  var inAppPurchaseService: AnyInAppPurchaseService<PurchaseID> {
    get { self[InAppPurchaseServiceKey.self] }
    set { self[InAppPurchaseServiceKey.self] = newValue }
  }
}

import CoreDataService
private enum PrivateDatabaseServiceKey: DependencyKey {
  static let liveValue: any DatabaseService = CoreDataService()
  static let testValue: any DatabaseService = .mock
  static let previewValue: any DatabaseService = .mock
}

import CloudKitService
private enum PublicDatabaseServiceKey: DependencyKey {
  static let liveValue: any DatabaseService = CloudKitService(container: CKContainer(identifier: Config.id.cloudKit))
  static let testValue: any DatabaseService = .mock
  static let previewValue: any DatabaseService = .mock
}

import MyAuthenticationService
private enum AuthenticationServiceKey: DependencyKey {
  static let liveValue: any AuthenticationService = MyAuthenticationService(server: .api)
  static let testValue: any AuthenticationService = .mock
  static let previewValue: any AuthenticationService = .mock
}

import UserNotificationsService
private enum NotificationServiceKey: DependencyKey {
  static let liveValue: any PushNotificationService = UserNotificationsService()
  static let testValue: any PushNotificationService = .mock
  static let previewValue: any PushNotificationService = .mock
}

import StoreKitService
private enum InAppPurchaseServiceKey: DependencyKey {
  static let liveValue: AnyInAppPurchaseService<PurchaseID> = .storekit
  static let testValue: AnyInAppPurchaseService<PurchaseID> = .mock
  static let previewValue: AnyInAppPurchaseService<PurchaseID> = .mock
}

import CoreSpotlightService
private enum IndexingServiceKey: DependencyKey {
  static let liveValue: IndexingService = CoreSpotlightService(appname: Config.appname)
  static let testValue: IndexingService = .mock
  static let previewValue: IndexingService = .mock
}
