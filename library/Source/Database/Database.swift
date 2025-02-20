// Created by Leopold Lemmermann on 20.02.25.

public struct Database<T: PersistentModel>: Sendable {
  public var insert: @MainActor @Sendable (T) async throws -> Void
  public var fetch: @MainActor @Sendable (FetchDescriptor<T>) async throws -> [T]
  public var delete: @MainActor @Sendable (T) async throws -> Void
}

extension Database: DependencyKey {
  public static var liveValue: Database<T> {
    Database<T>(
      insert: { model in
        @Dependency(\.data.context) var makeContext
        makeContext().insert(model)
        try makeContext().save()
      },
      fetch: { descriptor in
        @Dependency(\.data.context) var makeContext
        return try makeContext().fetch(descriptor)
      },
      delete: { model in
        @Dependency(\.data.context) var makeContext
        try makeContext().save()
        makeContext().delete(model)
      }
    )
  }
}
