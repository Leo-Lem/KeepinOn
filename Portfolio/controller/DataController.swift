//
//  DataController.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import CoreData

final class DataController: ObservableObject {
    
    let container: NSPersistentCloudKitContainer
    
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
    
    func save() throws {
        if container.viewContext.hasChanges { try container.viewContext.save() }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
}

//MARK: - Examples and Previews
#if DEBUG
extension DataController {
    
    func createSampleData() throws {
        let context = container.viewContext
        
        for i in 1...5 {
            let project = Project(context: context)
            project.title = "Project \(i)"
            project.items = []
            project.timestamp = Date()
            project.open = Bool.random()
            
            for j in 1...10 {
                let item = Item(context: context)
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
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        try container.viewContext.execute(batchDeleteRequest1)

        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        try container.viewContext.execute(batchDeleteRequest2)
    }
    
}
#endif
