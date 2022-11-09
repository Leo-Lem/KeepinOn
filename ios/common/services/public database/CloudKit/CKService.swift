//	Created by Leopold Lemmermann on 23.10.22.

import CloudKit
import Combine

final class CKService: PublicDatabaseService {
  let didChange = PassthroughSubject<Void, Never>()

  private(set) var status: PublicDatabaseStatus = .readOnly

  static let containerID = "iCloud.LeoLem.KeepinOn"
  private var container: CKContainer!

  private let tasks = Tasks()

  init() async {
    container = CKContainer(identifier: Self.containerID)
    tasks.add(statusUpdateOnCloudKitChange(), periodicRefresh(every: 60))
    await updateStatus()
  }

  @discardableResult
  func publish<T: PublicModelConvertible>(_ convertible: T) async throws -> T {
    try await mapCKError {
      let record = try await mapToCKRecord(convertible)
      try await publicDatabase.save(record)
      didChange.send()
      return convertible
    }
  }

  func unpublish(with id: String) async throws {
    try await mapCKError {
      try await publicDatabase.deleteRecord(withID: CKRecord.ID(recordName: id))
      didChange.send()
    }
  }

  func exists(with id: String) async throws -> Bool {
    try await mapCKError {
      do {
        try await publicDatabase.record(for: CKRecord.ID(recordName: id))
        return true
      } catch let error as CKError where error.code == .unknownItem {
        return false
      }
    }
  }

  func fetch<T: PublicModelConvertible>(with id: String) async throws -> T? {
    try await mapCKError {
      do {
        let record = try await publicDatabase.record(for: CKRecord.ID(recordName: id))
        return try await mapFromCKRecord(record)
      } catch let error as CKError where error.code == .unknownItem {
        return nil
      }
    }
  }

  func fetch<T: PublicModelConvertible>(_ query: Query<T>) throws -> AnyPublisher<T, Error> {
    let ckQuery = try getCKQuery(from: query)

    return fetch(ckQuery: ckQuery, maxItems: query.options.maxItems ?? 100)
      .flatMap(mapFromCKRecord)
      .mapError(mapCKError)
      .eraseToAnyPublisher()
  }

  func fetchReferencesToModel<T, U>(with id: String, of type: T.Type) throws -> AnyPublisher<U, Error>
    where T: PublicModelConvertible, U: PublicModelConvertible
  {
    let ref = CKRecord.Reference(recordID: CKRecord.ID(recordName: id), action: .deleteSelf)
    let query: Query<U>

    switch T.self {
    case is Project.Shared.Type:
      query = Query<U>(Project.Shared.ckIdentifier.lowercased(), .equal, ref)
    case is Item.Shared.Type:
      query = Query<U>(Item.Shared.ckIdentifier.lowercased(), .equal, ref)
    case is Comment.Type:
      query = Query<U>(Comment.ckIdentifier.lowercased(), .equal, ref)
    case is User.Type:
      query = Query<U>(User.ckIdentifier.lowercased(), .equal, ref)
    default:
      throw PublicDatabaseError.mappingToPublicModel(from: type)
    }

    return try fetch(query)
  }
}

extension CKService {
  var publicDatabase: CKDatabase { container.publicCloudDatabase }
}

private extension CKService {
  func statusUpdateOnCloudKitChange() -> Task<Void, Never> {
    NotificationCenter.default
      .publisher(for: .CKAccountChanged)
      .getTask { [weak self] _ in await self?.updateStatus() }
  }

  func periodicRefresh(every interval: TimeInterval) -> Task<Void, Never> {
    Timer
      .publish(every: interval, on: .main, in: .default)
      .getTask { [weak self] _ in self?.didChange.send()}
  }

  func updateStatus() async {
    do {
      status = try await container.accountStatus() == .available ? .available : .readOnly
    } catch let error as CKError where error.code == .networkFailure || error.code == .networkUnavailable {
      status = .unavailable(error)
    } catch { print(error.localizedDescription) }
  }

  func fetch(ckQuery: CKQuery, maxItems: Int? = nil) -> PassthroughSubject<CKRecord, Error> {
    let pub = PassthroughSubject<CKRecord, Error>()

    Task(priority: .userInitiated) {
      var count = 0
      var cursor: CKQueryOperation.Cursor?

      do {
        let result = try await publicDatabase.records(matching: ckQuery, resultsLimit: 1)
        cursor = result.queryCursor
        if let record = try result.matchResults.first?.1.get() {
          pub.send(record)
        }

        while let c = cursor, count <= maxItems ?? 100 {
          let result = try await publicDatabase.records(continuingMatchFrom: c, resultsLimit: 1)
          cursor = result.queryCursor
          count += 1
          if let record = try result.matchResults.first?.1.get() {
            pub.send(record)
          }
        }

        pub.send(completion: .finished)
      } catch {
        pub.send(completion: .failure(error))
      }
    }

    return pub
  }
}

private extension CKService {
  func mapCKError(_ error: Error) -> Error {
    do {
      try mapCKError { throw error }
      return error
    } catch { return error }
  }

  func mapCKError<T>(_ action: () throws -> T) rethrows -> T {
    do {
      return try action()
    } catch let error as CKError {
      throw PublicDatabaseError(ckError: error)
    } catch {
      throw error
    }
  }

  func mapCKError<T>(_ action: () async throws -> T) async rethrows -> T {
    do {
      return try await action()
    } catch let error as CKError {
      throw PublicDatabaseError(ckError: error)
    } catch {
      throw error
    }
  }
}

#if DEBUG
extension CKService {
  func deleteAll() async {
    await printError {
      let queries: [CKQuery] = [
        CKQuery(recordType: Project.Shared.ckIdentifier, predicate: .init(value: true)),
        CKQuery(recordType: Item.Shared.ckIdentifier, predicate: .init(value: true)),
        CKQuery(recordType: Comment.ckIdentifier, predicate: .init(value: true)),
        CKQuery(recordType: User.ckIdentifier, predicate: .init(value: true)),
        CKQuery(recordType: Credential.ckIdentifier, predicate: .init(value: true))
      ]

      var ids = [CKRecord.ID]()

      for query in queries {
        ids += try await publicDatabase.records(matching: query).matchResults.map(\.0)
      }

      _ = try await publicDatabase.modifyRecords(saving: [], deleting: ids)

      didChange.send()
    }
  }
}
#endif
