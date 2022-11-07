//	Created by Leopold Lemmermann on 29.10.22.

protocol KeyValueService {
  func insert<T>(_ item: T, for key: String) throws
  func load<T>(for key: String) throws -> T?
  func delete(for key: String) throws
}

// MARK: - (CONVENIENCE)

import Foundation

extension KeyValueService {
  func insert<T: Encodable>(
    object: T,
    encoder: JSONEncoder = .init(),
    for key: String
  ) throws {
    try insert(try encoder.encode(object), for: key)
  }

  func fetchObject<T: Decodable>(
    decoder: JSONDecoder = .init(),
    for key: String
  ) throws -> T? {
    if let data: Data = try load(for: key) {
      return try decoder.decode(T.self, from: data)
    } else { return nil }
  }
}
