//
//  DataController.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import CoreData
import MyData
import MyOthers

/// An environment singleton responsible for managing our Core Data stack, including handling saving,
/// counting fetch requests, tracking awards, and dealing with sample data.
final class DataController: ObservableObject {

    /// The lone CloudKit container used to store all our data.
    let container: NSPersistentCloudKitContainer

    var context: NSManagedObjectContext { container.viewContext }
    
    /// Initializes a data controller, either in memory (for temporary use such as testing and previewing),
    /// or on permanent storage (for use in regular app runs).
    /// - Parameter inMemory: Whether to store this data in temporary memory or not. Defaults to permanent storage.
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error)")
            }
        }
    }

    /// Saves our Core Data context iff there are changes. This silently ignores
    /// any errors caused by saving, but this should be fine because all our attributes are optional.
    func save() {
        if context.hasChanges {
            do { try context.save() } catch { print("saving failed") }
        }
    }

    /// Deletes a given object from our Core Data context.
    /// - Parameter object: Some NSManagedObject to be deleted.
    func delete<T: CDRepresentable>(_ object: T) {
        context.delete(object.cd)
    }
    
}

// MARK: - (fetching)
extension DataController {
    
    /// Gets the count of fetched items for a given fetch request
    /// - Parameter for: A generic fetch request.
    /// - Returns: A count of fetched items. Defaults to 0.
    func count<T>(for request: NSFetchRequest<T>) throws -> Int {
        try context.count(for: request)
    }
    
}

#if DEBUG
// MARK: - (Examples and Previews)
extension DataController {

    /// Creates example projects and items to make manual testing easier.
    /// - Throws: An NSError sent from calling save() on the NSManagedObjectContext.
    func createSampleData() throws {
        let context = container.viewContext

        for i in 1...5 { // swiftlint:disable:this identifier_name
            let project = CDProject(context: context)
            project.title = "Project \(i)"
            project.items = []
            project.timestamp = Date()
            project.closed = Bool.random()
            
            for j in 1...10 { // swiftlint:disable:this identifier_name
                let item = CDItem(context: context)
                    item.title = "Item \(j)"
                    item.timestamp = Date()
                    item.completed = Bool.random()
                    item.project = project
                    item.priority = Int16.random(in: 1...3)
            }
        }

        try context.save()
    }

    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let context = dataController.container.viewContext

        do {
            try dataController.createSampleData()
        } catch { fatalError("Fatal error creating previews: \(error)") }

        return dataController
    }()

    func deleteAll() throws {
        let fetchRequests: [NSFetchRequest<NSFetchRequestResult>] = [CDItem.fetchRequest(), CDProject.fetchRequest()],
        batchDeleteRequests = fetchRequests.map(NSBatchDeleteRequest.init)

        try batchDeleteRequests.forEach { request in
            try container.viewContext.execute(request)
        }
    }

}
#endif
