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
        container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error)")
            }
        }
    }
    
    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }

        return managedObjectModel
    }()
    
}

// MARK: - (helper methods)
extension DataController {
    
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
    
    /// Gets the count of fetched items for a given fetch request
    /// - Parameter for: A generic fetch request.
    /// - Returns: A count of fetched items. Defaults to 0.
    func count<T>(for request: NSFetchRequest<T>) -> Int {
        (try? context.count(for: request)) ?? 0
    }
    
}
