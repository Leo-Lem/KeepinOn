//	Created by Leopold Lemmermann on 23.10.22.

import CoreData

extension NSManagedObjectContext {
  func saveIfChanged() throws {
    if hasChanges { try save() }
  }
}

extension NSManagedObjectContext {
  func fetch<T: NSManagedObject>(with id: UUID) -> T? {
    do {
      let request = T.fetchRequest()
      request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
      return try fetch(request).first as? T
    } catch {
      print("Failed to fetch NSMO for UUID: \(id)")
      return nil
    }
  }
}
