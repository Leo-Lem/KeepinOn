// Created by Leopold Lemmermann on 15.02.25.

@_exported import Dependencies
@_exported import SwiftData

/// For internal use. The ModelContainer has to be initialized, though.
public struct SwiftDatabase: Sendable {
  var context: @MainActor @Sendable () -> ModelContext
}

extension SwiftDatabase: DependencyKey {
  /// Configure the container using this static property.
  @MainActor public static var container: ModelContainer?
  @MainActor public static let context = {
    guard let container else { fatalError("Configure the `SwiftDatabase.ModelContainer` first!") }
    return ModelContext(container)
  }()
  public static let liveValue = SwiftDatabase(
    context: { Self.context }
  )
}

extension DependencyValues {
  var data: SwiftDatabase {
    get { self[SwiftDatabase.self] }
    set { self[SwiftDatabase.self] = newValue }
  }
}
