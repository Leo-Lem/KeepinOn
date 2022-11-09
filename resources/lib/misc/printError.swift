//	Created by Leopold Lemmermann on 31.10.22.

@discardableResult
func printError<T>(_ action: () throws -> T) -> T? {
  do {
    return try action()
  } catch {
    debugPrint(error.localizedDescription)
  }
  return nil
}

@discardableResult
func printError<T>(_ action: () async throws -> T) async -> T? {
  do {
    return try await action()
  } catch {
    debugPrint(error.localizedDescription)
  }
  return nil
}

@discardableResult
func printError<T>(_ action: () throws -> T?) -> T? {
  do {
    return try action()
  } catch {
    debugPrint(error.localizedDescription)
  }
  return nil
}

@discardableResult
func printError<T>(_ action: () async throws -> T?) async -> T? {
  do {
    return try await action()
  } catch {
    debugPrint(error.localizedDescription)
  }
  return nil
}
