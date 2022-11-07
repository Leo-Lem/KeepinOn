//	Created by Leopold Lemmermann on 25.10.22.

import CoreData

protocol CDConvertible: PrivateModelConvertible {
  associatedtype CDModel: NSManagedObject
  static var cdIdentifier: String { get }
  init(from cdModel: CDModel, withRelationships: Bool)
  func mapToCDModel(in context: NSManagedObjectContext) -> CDModel
}
