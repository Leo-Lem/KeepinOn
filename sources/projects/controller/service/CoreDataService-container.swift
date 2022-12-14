//	Created by Leopold Lemmermann on 09.11.22.

import CoreDataService

extension CoreDataService {
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

  init(inMemory: Bool = false) async {
    let container = NSPersistentCloudKitContainer(
      name: Self.containerID,
      managedObjectModel: Self.managedObjectModel
    )

    container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump

    if inMemory {
      container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    }

    container.loadPersistentStores { _, error in
      if let error = error {
        fatalError("Failed to load persistent store: \(error.localizedDescription)")
      }
    }

    await self.init(context: container.viewContext)
  }
}
