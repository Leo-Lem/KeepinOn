//	Created by Leopold Lemmermann on 17.10.22.

import Combine
import Foundation

protocol PrivateDatabaseService: ObservableService {
  @discardableResult
  func insert<T: PrivateModelConvertible>(_ model: T) throws -> T
  func delete(with id: UUID) throws
  func count<T: PrivateModelConvertible>(_ query: Query<T>) throws -> Int
  func fetch<T: PrivateModelConvertible>(_ query: Query<T>) throws -> [T]
}

// MARK: - (CONVENIENCE)

extension PrivateDatabaseService {
  func fetch<T: PrivateModelConvertible>(_ model: PrivateModelConvertible) throws
    -> T? { try fetch(with: model.stringID) }
  func fetch<T: PrivateModelConvertible>(with id: UUID) throws -> T? { try fetch(with: id.uuidString) }
  func fetch<T: PrivateModelConvertible>(with id: String) throws -> T? {
    let query = Query<T>(propertyName: "id", .eq, id)
    let result = try fetch(query)
    return result.first
  }
}
