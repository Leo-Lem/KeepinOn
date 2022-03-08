//
//  SpotlightController.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 08.03.22.
//

import CoreSpotlight
import MyData

final class SpotlightController {
    
    private let dataController: DataController
    init(dataController: DataController) { self.dataController = dataController }
    
    func update(_ item: Item) {
        let id: (item: String, project: String?) = (item.idString, item.project?.idString)
        
        let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
        attributeSet.title = item.title
        attributeSet.contentDescription = item.details
        
        let searchableItem = CSSearchableItem(
            uniqueIdentifier: id.item,
            domainIdentifier: id.project,
            attributeSet: attributeSet
        )
        
        CSSearchableIndex.default().indexSearchableItems([searchableItem])
    }
    
    func item(with id: String) -> Item? {
        guard
            let url = URL(string: id),
            let id = dataController.container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url),
            let cd = try? dataController.context.existingObject(with: id) as? Item.CD
        else { return nil }
        
        return Item(cd)
    }
    
    func delete<T: CDRepresentable>(_ object: T) {
        let id = object.idString
        switch object {
        case is Item: CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [id])
        case is Project: CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id])
        default: break
        }
    }
    
}
