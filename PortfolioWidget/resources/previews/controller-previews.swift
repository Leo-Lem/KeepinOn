//
//  controller-previews.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 14.03.22.
//

import CoreData

extension DataController {

    var exampleCount: (projects: Int, itemsPerProject: Int) { (5, 10) }
    
    /// Creates example projects and items to make manual testing easier.
    /// - Throws: An NSError sent from calling save() on the NSManagedObjectContext.
    func createSampleData() throws {
        let context = container.viewContext

        for i in 1...exampleCount.projects { // swiftlint:disable:this identifier_name
            let project = CDProject(context: context)
            project.title = "Project \(i)"
            project.items = []
            project.timestamp = Date()
            project.closed = Bool.random()
            
            for j in 1...exampleCount.itemsPerProject { // swiftlint:disable:this identifier_name
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

}
