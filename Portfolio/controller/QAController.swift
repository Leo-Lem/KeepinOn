//
//  QAController.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 08.03.22.
//

import CoreSpotlight
import MyData

// MARK: - (Spotlight)

/// QAController (Quick Action Controller) deals with everything regarding system-wide integration.
///
/// Deals with things, such as:
/// - home screen quick actions
/// - spotlight search
/// - user activities
final class QAController {
    
    private let dataController: DataController
    init(dataController: DataController) { self.dataController = dataController }
    
    /// <#Description#>
    /// - Parameter item: <#item description#>
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

// MARK: - (Activities)
extension QAController {
    
    enum UserActivityType: String {
        case addProject
        
        var id: String { "\(Self.prefix)\(rawValue)" }
        
        private static let prefix = "LeoLem.Portfolio."
    }
    
}

extension String {
    init(_ userActivityType: QAController.UserActivityType) {
        self.init(userActivityType.id)
    }
}

// MARK: - (Home screen quick actions)
extension QAController {
    
    func checkQATriggered() -> QuickAction? {
        guard let url = AppDelegate.shortcutItem?.type else { return nil }
        
        return QuickAction(url: url)
    }
    
    enum QuickAction: String {
        case addProject
        
        var url: String { "\(Self.prefix)\(rawValue)" }
        
        init?(url: String) {
            guard url.hasPrefix(Self.prefix) else { return nil }
            
            let rawValue = String(url.dropFirst(Self.prefix.count))
            
            self.init(rawValue: rawValue)
        }
        
        private static let prefix = "portfolio://"
    }
    
}
