//	Created by Leopold Lemmermann on 20.10.22.

import Combine
import Foundation

final class MockPrivateDatabaseService: PrivateDatabaseService {
  var didChange = PassthroughSubject<Void, Never>()

  func insert<T: PrivateModelConvertible>(_ model: T) -> T {
    print("Inserted \(model) into private database.")
    return model
  }

  func delete(with id: UUID) {
    print("Deleted model with \(id) in private database.")
  }

  func count<T: PrivateModelConvertible>(_ query: Query<T>) -> Int {
    print("Counted \(query) in private database.")
    return Int.random(in: 0..<100)
  }

  func fetch<T: PrivateModelConvertible>(_ query: Query<T>) -> [T] {
    print("Fetched \(query) from private database.")
    return []
  }
}
