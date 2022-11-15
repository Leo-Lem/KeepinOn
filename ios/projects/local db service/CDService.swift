//	Created by Leopold Lemmermann on 09.11.22.

import CoreData
import CoreDataService

class CDService: CoreDataService {
  static let containerID = "Main"

  static let managedObjectModel: NSManagedObjectModel = {
    guard let url = Bundle.main.url(forResource: containerID, withExtension: "momd") else {
      fatalError("Failed to locate model file.")
    }

    guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
      fatalError("Failed to load model file.")
    }

    return managedObjectModel
  }()

  init(inMemory: Bool = false) {
    let container = NSPersistentCloudKitContainer(
      name: Self.containerID,
      managedObjectModel: Self.managedObjectModel
    )

    container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump

    super.init(inMemory: inMemory, container: container)
  }
}
