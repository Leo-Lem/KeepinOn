//	Created by Leopold Lemmermann on 04.12.22.

import DatabaseService

extension MainState {
  func displayError<T>(_ throwing: () throws -> T) rethrows -> T {
    do { return try throwing() } catch let error as DatabaseError where error.hasDescription {
      presentation.alert = .remoteDBError(error)
      throw error
    }
  }

  @_disfavoredOverload
  func displayError<T>(_ throwing: () async throws -> T) async rethrows -> T {
    do { return try await throwing() } catch let error as DatabaseError where error.hasDescription {
      presentation.alert = .remoteDBError(error)
      throw error
    }
  }
}
