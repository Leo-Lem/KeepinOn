// Created by Leopold Lemmermann on 19.12.22.

import ComposableArchitecture

extension DependencyValues {
  var privateDatabaseService: any DatabaseService { self[PrivateDatabaseServiceKey.self] }
  var indexingService: any IndexingService { self[IndexingServiceKey.self] }
  var publicDatabaseService: any DatabaseService { self[PublicDatabaseServiceKey.self] }
  var authenticationService: any AuthenticationService { self[AuthenticationServiceKey.self] }
  var pushNotificationService: any PushNotificationService { self[NotificationServiceKey.self] }
  var inAppPurchaseService: AnyInAppPurchaseService<PurchaseID> { self[InAppPurchaseServiceKey.self] }
  var keyValueStorageService: AnyKeyValueStorageService<String> { self[KeyValueStorageServiceKey.self] }
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

import UserDefaultsService
private enum KeyValueStorageServiceKey: DependencyKey {
  static let liveValue: AnyKeyValueStorageService<String> = .userDefaults(cloudDefaults: .init())
  static let testValue: AnyKeyValueStorageService<String> = .mock
  static let previewValue: AnyKeyValueStorageService<String> = .mock
}
