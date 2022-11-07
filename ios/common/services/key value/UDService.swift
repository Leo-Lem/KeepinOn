//	Created by Leopold Lemmermann on 29.10.22.

import Foundation

final class UDService: KeyValueService {
  func insert<T>(_ item: T, for key: String) throws {
    store.set(item, forKey: key)
  }

  func load<T>(for key: String) throws -> T? {
    store.object(forKey: key) as? T
  }

  func delete(for key: String) throws {
    store.removeObject(forKey: key)
  }

  private var store: UserDefaults { .standard }
}
