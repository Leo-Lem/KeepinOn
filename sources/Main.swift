//  Created by Leopold Lemmermann on 24.10.22.

import AwardsController
import CloudKitService
import Concurrency
import CoreDataService
import CoreSpotlightService
import Errors
import MyAuthenticationService
import StoreKitService
import SwiftUI
import UserNotificationsService

@main struct Main: App {
  var body: some Scene {
    WindowGroup {
      if isReady {
        EntryView()
          .environmentObject(projectsController)
          .environmentObject(communityController)
          .environmentObject(accountController)
          .environmentObject(iapController)
          .environmentObject(awardsController)
      } else {
        ProgressView()
          .accessibilityIdentifier("app-is-loading-indicator")
          .onAppear { Task(priority: .userInitiated) { await setup() } }
      }
    }
  }
  
  @State private var isReady = false

  @State var projectsController: ProjectsController!
  @State private var communityController: CommunityController!
  @State private var accountController: AccountController!
  @State private var iapController: IAPController!
  @State private var awardsController: AwardsController!

  #if os(iOS)
  @State var widgetController: WidgetController!
  #endif

  private let tasks = Tasks()

  @MainActor private func setup() async {
    let publicDBService = await CloudKitService(container: CKContainer(identifier: Config.id.cloudKit))
    let privateDBService = await CoreDataService()
    let indexingService = CoreSpotlightService()
    let notificationService = await UserNotificationsService()
    let authService = await MyAuthenticationService(server: URL(string: "https://auth.leolem.de")!)
    let purchaseService: AnyInAppPurchaseService<PurchaseID> = await .storekit()
    
    awardsController = await AwardsController()
    projectsController = await ProjectsController(
      databaseService: privateDBService, indexingService: indexingService, notificationService: notificationService
    )
    communityController = CommunityController(databaseService: publicDBService)
    accountController = await AccountController(databaseService: publicDBService, authService: authService)
    iapController = IAPController(service: purchaseService)

    #if os(iOS)
    tasks["updateWidgets"] = projectsController?.databaseService.handleEventsTask(.background, with: setWidgets)
    #endif
    
    #if DEBUG
    if CommandLine.arguments.contains("--test") {
      print("!!! TEST SESSION !!!")

      await privateDBService.deleteAll()
      await publicDBService.deleteAll()
      awardsController.resetProgress()
      printError(accountController.authService.logout)
    }

    tasks.add(
      privateDBService.handleEventsTask { print("PrivateDBService: \($0)") },
      publicDBService.handleEventsTask { print("PublicDBService: \($0)") },
      purchaseService.handleEventsTask { print("PurchaseService: \($0)") },
      notificationService.handleEventsTask { print("NotificationService: \($0)") },
      authService.handleEventsTask { print("AuthenticationService: \($0)") }
    )
    #endif
    
    isReady = true
  }
}
