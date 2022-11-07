//	Created by Leopold Lemmermann on 24.10.22.

import CloudKit

extension CKService {
  func mapToCKRecord<T: PublicModelConvertible>(_ convertible: T) async throws -> CKRecord {
    if let convertible = convertible as? any CKConvertible {
      let existingRecord = try? await publicDatabase.record(for: .init(recordName: convertible.stringID))
      let record = convertible.mapToCKRecord(existing: existingRecord)

      return record
    } else {
      throw PublicDatabaseError.mappingToPublicModel(from: T.self)
    }
  }

  func mapFromCKRecord<T: PublicModelConvertible>(_ record: CKRecord) async throws -> T {
    let convertible: PublicModelConvertible

    do {
      let refs = try await fetchReferences(in: record)

      switch record.recordType {
      case Project.Shared.ckIdentifier:
        convertible = Project.Shared(from: record, refs: refs)
      case Item.Shared.ckIdentifier:
        convertible = Item.Shared(from: record, refs: refs)
      case Comment.ckIdentifier:
        convertible = Comment(from: record, refs: refs)
      case User.ckIdentifier:
        convertible = User(from: record, refs: refs)
      case Credential.ckIdentifier:
        convertible = Credential(from: record, refs: refs)
      default:
        throw PublicDatabaseError.mappingFromPublicModel(to: T.self)
      }
    } catch {
      throw PublicDatabaseError.mappingFromPublicModel(to: T.self)
    }

    if let c = convertible as? T { return c } else {
      throw PublicDatabaseError.mappingToPublicModel(from: T.self)
    }
  }

  func getCKQuery<T: PublicModelConvertible>(from query: Query<T>) throws -> CKQuery {
    var identifier: String

    switch T.self {
    case is Project.Shared.Type:
      identifier = Project.Shared.ckIdentifier
    case is Item.Shared.Type:
      identifier = Item.Shared.ckIdentifier
    case is Comment.Type:
      identifier = Comment.ckIdentifier
    default:
      throw PublicDatabaseError.mappingToPublicModel(from: T.self)
    }

    return CKQuery(recordType: identifier, predicate: NSPredicate(query: query))
  }
}

private extension CKService {
  func fetchReferences(in record: CKRecord) async throws -> [CKRecord] {
    var refs = [CKRecord]()

    for property in ["project", "user"] {
      if let ref = record[property] as? CKRecord.Reference {
        refs.append(try await publicDatabase.record(for: ref.recordID))
      }
    }

    return refs
  }
}
