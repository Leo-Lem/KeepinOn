// Created by Leopold Lemmermann on 13.12.22.

import AuthenticationService
import Foundation
import Concurrency
import DatabaseService

@MainActor class AccountController: ObservableObject {
  @Published var databaseAvailable: Bool!
  @Published var user: User?
  @Published var id: User.ID?
  
  var canPublish: Bool { databaseAvailable && isAuthenticated }
  var isAuthenticated: Bool { id != nil }
  
  let databaseService: any DatabaseService
  let authService: any AuthenticationService
  
  private let tasks = Tasks()
  
  init(databaseService: any DatabaseService, authService: any AuthenticationService) async {
    self.databaseService = databaseService
    self.authService = authService
    
    databaseAvailable = await getDatabaseAvailable()
    id = getID()
    if databaseAvailable { user = try? await getUser(for: id) }
    
    tasks.add(
      databaseService.handleEventsTask(.background, with: setUserAndDatabaseAvailable),
      authService.handleEventsTask(.background, with: setIDAndUser)
    )
  }
}
