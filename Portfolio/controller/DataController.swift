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
    
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
    
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "items":
            let fetchRequest = NSFetchRequest<Item>(entityName: "Item")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
            
        case "complete":
            let fetchRequest = NSFetchRequest<Item>(entityName: "Item")
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
            
        default:
            // fatalError("Unknown award criterion \(award.criterion).")
            return false
        }
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
            project.closed = Bool.random()
            
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
        let fetchRequests: [NSFetchRequest<NSFetchRequestResult>] = [Item.fetchRequest(), Project.fetchRequest()],
        batchDeleteRequests = fetchRequests.map(NSBatchDeleteRequest.init)
        
        try batchDeleteRequests.forEach { request in
            try container.viewContext.execute(request)
        }
    }
    
}
#endif
