//
//  Item.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import CoreData

@objc(Item)
class Item: NSManagedObject {}

//MARK: - convenience extensions
extension Item {

    var itemDetails: String {
        details ?? ""
    }

    var itemTimestamp: Date {
        timestamp ?? Date()
    }
    
}

//MARK: - Example
#if DEBUG
extension Item {
    
    static var example: Item {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let item = Item(context: viewContext)
        item.title = "Example Item"
        item.details = "This is an example item"
        item.priority = 3
        item.timestamp = Date()
        return item
    }
    
}
#endif
