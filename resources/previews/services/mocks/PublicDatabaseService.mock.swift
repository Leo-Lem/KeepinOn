//	Created by Leopold Lemmermann on 23.10.22.

import Combine
import Foundation

final class MockPublicDatabaseService: PublicDatabaseService {
  let didChange = PassthroughSubject<Void, Never>()

  var status: PublicDatabaseStatus = .available

  func publish<T: PublicModelConvertible>(_ convertible: T) async throws -> T {
    print("Published \(convertible)!")
    return convertible
  }

  func unpublish(with id: String) async throws {
    print("Deleted record with \(id)!")
  }

  func exists(with id: String) async throws -> Bool {
    .random()
  }

  func fetch<T: PublicModelConvertible>(with id: String) async throws -> T? {
    print("Fetched object with \(id)")
    return nil
  }

  func fetch<T>(_ query: Query<T>) throws -> AnyPublisher<T, Error> where T: PublicModelConvertible {
    print("Fetched \(query)!")
    return PassthroughSubject().eraseToAnyPublisher()
  }

  func fetchReferencesToModel<T, U>(with id: String, of type: T.Type) throws -> AnyPublisher<U, Error>
    where T: PublicModelConvertible, U: PublicModelConvertible
  {
    print("Fetched references to model with id \(id)")
    return PassthroughSubject().eraseToAnyPublisher()
  }
}
