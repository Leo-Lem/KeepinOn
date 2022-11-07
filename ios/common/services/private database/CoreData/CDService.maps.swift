//	Created by Leopold Lemmermann on 24.10.22.

import CoreData

extension CDService {
  func mapToNSManagedObject<T: PrivateModelConvertible>(
    _ convertible: T,
    context: NSManagedObjectContext
  ) throws -> NSManagedObject {
    if let convertible = convertible as? any CDConvertible {
      return convertible.mapToCDModel(in: context)
    } else {
      throw PrivateDatabaseError.mappingToPrivateModel(from: T.self)
    }
  }

  func mapFromNSManagedObject<T: PrivateModelConvertible>(_ object: NSManagedObject) throws -> T {
    let convertible: PrivateModelConvertible

    switch object {
    case let cdProject as Project.CDModel:
      convertible = Project(from: cdProject)
    case let cdItem as Item.CDModel:
      convertible = Item(from: cdItem)
    default:
      throw PrivateDatabaseError.mappingFromPrivateModel(to: T.self)
    }

    if let c = convertible as? T { return c } else {
      throw PrivateDatabaseError.mappingToPrivateModel(from: T.self)
    }
  }

  func getNSFetchRequest<T: PrivateModelConvertible>(from query: Query<T>) throws
    -> NSFetchRequest<NSFetchRequestResult>
  {
    let request = try getBaseNSFetchRequest(for: T.self)
    request.predicate = NSPredicate(query: query)
    return request
  }

  func getBaseNSFetchRequest(for type: PrivateModelConvertible.Type) throws -> NSFetchRequest<NSFetchRequestResult> {
    switch type {
    case is Project.Type:
      return CDProject.fetchRequest()
    case is Item.Type:
      return CDItem.fetchRequest()
    default:
      throw PrivateDatabaseError.mappingToPrivateModel(from: type)
    }
  }
}
