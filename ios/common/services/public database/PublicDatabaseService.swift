//	Created by Leopold Lemmermann on 21.10.22.

import Combine

protocol PublicDatabaseService {
  var didChange: PassthroughSubject<Void, Never> { get }

  var status: PublicDatabaseStatus { get }

  @discardableResult
  func publish<T: PublicModelConvertible>(_ convertible: T) async throws -> T
  func unpublish(with id: String) async throws

  func exists(with id: String) async throws -> Bool
  func fetch<T: PublicModelConvertible>(with id: String) async throws -> T?

  func fetch<T: PublicModelConvertible>(_ query: Query<T>) throws -> AnyPublisher<T, Error>
  func fetchReferencesToModel<T, U>(with id: String, of type: T.Type) throws -> AnyPublisher<U, Error>
    where T: PublicModelConvertible, U: PublicModelConvertible
}

// MARK: - (CONVENIENCE)

import Foundation

extension PublicDatabaseService {
  // batch operations
  @_disfavoredOverload
  @discardableResult
  func publish(_ models: any PublicModelConvertible...) async throws -> [any PublicModelConvertible] {
    try await publish(models)
  }
  
  @discardableResult
  func publish(_ models: [any PublicModelConvertible]) async throws -> [any PublicModelConvertible] {
    for model in models { try await publish(model) }
    return models
  }

  @_disfavoredOverload
  @discardableResult
  func unpublish(_ models: any PublicModelConvertible...) async throws -> [any PublicModelConvertible] {
    try await unpublish(models)
  }

  @discardableResult
  func unpublish(_ models: [any PublicModelConvertible]) async throws -> [any PublicModelConvertible] {
    for model in models { try await unpublish(model) }
    return models
  }

  // model variants for id fetching
  func unpublish<T: PublicModelConvertible>(_ model: T) async throws {
    try await unpublish(with: model.stringID)
  }

  func fetch<T: PublicModelConvertible>(_ model: T) async throws -> T? {
    try await fetch(with: model.stringID)
  }

  func fetchReferencesTo<T, U>(_ model: T) throws -> AnyPublisher<U, Error>
    where T: PublicModelConvertible, U: PublicModelConvertible
  {
    try fetchReferencesToModel(with: model.stringID, of: T.self)
  }

  func fetchReferencesToModel<T, U>(_ model: T) async throws -> [U]
    where T: PublicModelConvertible, U: PublicModelConvertible
  {
    try await fetchReferencesToModel(with: model.stringID, of: T.self)
  }

  // UUID variants
  func unpublish(with id: UUID) async throws {
    try await unpublish(with: id.uuidString)
  }

  func exists(with id: UUID) async throws -> Bool {
    try await exists(with: id.uuidString)
  }

  func fetch<T: PublicModelConvertible>(with id: UUID) async throws -> T? {
    try await fetch(with: id.uuidString)
  }

  func fetchReferencesToModel<T, U>(with id: UUID, of type: T.Type) throws -> AnyPublisher<U, Error>
    where T: PublicModelConvertible, U: PublicModelConvertible
  {
    try fetchReferencesToModel(with: id.uuidString, of: type)
  }

  func fetchReferencesToModel<T, U>(with id: UUID, of type: T.Type) async throws -> [U]
    where T: PublicModelConvertible, U: PublicModelConvertible
  {
    try await fetchReferencesToModel(with: id.uuidString, of: type)
  }

  // converting publishers to async output
  func fetch<T: PublicModelConvertible>(_ query: Query<T>) async throws -> [T] {
    let pub: AnyPublisher<T, Error> = try fetch(query)

    var values = [T]()
    for try await value in pub.values {
      values.append(value)
    }
    return values
  }

  func fetchReferencesToModel<T, U>(with id: String, of type: T.Type) async throws -> [U]
    where T: PublicModelConvertible, U: PublicModelConvertible
  {
    let pub: AnyPublisher<U, Error> = try fetchReferencesToModel(with: id, of: type)

    var values = [U]()
    for try await value in pub.values {
      values.append(value)
    }
    return values
  }
}
