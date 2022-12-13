// Created by Leopold Lemmermann on 13.12.22.

import Concurrency
import DatabaseService
import Errors
import LeosMisc

extension AccountController {
  func getUser(for id: User.ID?) async throws -> User? {
    try await id.flatMap { id in
      try await databaseService.fetch(with: id) ?? (try await databaseService.insert(User(id: id)))
    }
  }
  
  @inlinable func getDatabaseAvailable() async -> Bool {
    await databaseService.status == .available
  }

  func setUserAndDatabaseAvailable(on event: DatabaseEvent) async {
    await printError {
      switch event {
      case let .inserted(type, id) where type == User.self:
        if let id = id as? User.ID, id == self.id {
          user = try await getUser(for: id)
        }
      case let .deleted(type, id) where type == User.self && id as? User.ID == self.id:
        try authService.logout()
        user = nil
        self.id = nil
      case let .status(status) where status == .available:
        user = try await getUser(for: id)
      case .status:
        databaseAvailable = false
      case .remote:
        user ?= try await id.flatMap(getUser)
      default:
        break
      }
    }
  }
}
