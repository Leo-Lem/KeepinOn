// Created by Leopold Lemmermann on 20.02.25.

@_exported import SwiftDatabase

public extension SwiftDatabase {
  /// Hook up the database.
  @MainActor static func start() {
    do {
      SwiftDatabase.container = try ModelContainer(for: Project.self, Item.self)
    } catch {
      fatalError("Failed to create database container: \(error)")
    }
  }
}
