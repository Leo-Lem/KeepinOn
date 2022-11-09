//	Created by Leopold Lemmermann on 31.10.22.

final class MockKeyValueService: KeyValueService {
  func insert<T>(_ item: T, for key: String) throws {
    print("Inserted \(item) for \(key).")
  }

  func delete(for key: String) throws {
    print("Deleted item for \(key).")
  }

  func load<T>(for key: String) throws -> T? {
    print("Fetched item for key.")
    return nil
  }
}
