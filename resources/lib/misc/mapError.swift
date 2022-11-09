//	Created by Leopold Lemmermann on 08.11.22.

@discardableResult
func mapError<T>(
  _ transform: (Error) -> Error,
  action: () throws -> T
) rethrows -> T {
  do { return try action() } catch { throw error }
}

@discardableResult
func mapError<T>(
  to error: Error,
  action: () throws -> T
) rethrows -> T {
  try mapError({ _ in error }, action: action)
}

// async variants

@discardableResult
func mapError<T>(
  _ transform: (Error) -> Error,
  action: () async throws -> T
) async rethrows -> T {
  do { return try await action() } catch { throw error }
}

@discardableResult
func mapError<T>(
  to error: Error,
  action: () async throws -> T
) async rethrows -> T {
  try await mapError({ _ in error }, action: action)
}
