//
//  AppState.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 05.03.22.
//

import Foundation
import StoreKit
import CoreData
import MyData

final class AppState: ObservableObject {
    
    @Published var screen: ContentViewTab = .home
    @Published var itemSortOrder: Item.SortOrder = .optimized
    
    private let dataController: DataController,
                qaController: QAController,
                notificationController: NotificationController,
                widgetController: WidgetController
    
    let iapController: IAPController
    
    init(
        dataController: DataController = .init(),
        qaController: QAController = .init(),
        notificationController: NotificationController = .init(),
        widgetController: WidgetController = .init(),
        iapController: IAPController = .init()
    ) {
        self.dataController = dataController
        self.qaController = qaController
        self.notificationController = notificationController
        self.iapController = iapController
        self.widgetController = widgetController
    }
    
}

extension AppState {
    
    @discardableResult func addProject() -> Bool {
        let canCreate = iapController.fullVersionUnlocked || count(for: Project.CD.fetchRequest()) < 3
        
        if canCreate {
            _ = Project(in: viewContext)
            save()
        }
        
        return canCreate
    }
    
    /// Requesting review if at least 5 projects have been created.
    func requestFeedback() {
        guard count(for: Project.CD.fetchRequest()) >= 5 else { return }
        
        let allScenes = UIApplication.shared.connectedScenes
        let scene = allScenes.first { $0.activationState == .foregroundActive }
        if let windowScene = scene as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
}

// MARK: - (data handling)
extension AppState {
    
    var viewContext: NSManagedObjectContext { dataController.container.viewContext }
    
    func addItem(to project: Project) {
        _ = Item(in: viewContext, project: project)
    }
    
    func delete<T: CDRepresentable>(_ object: T) {
        dataController.delete(object)
        qaController.delete(object)
    }
    
    func count<T: NSManagedObject>(for request: NSFetchRequest<T>) -> Int {
        (try? dataController.count(for: request)) ?? 0
    }
    
    func save(_ item: Item? = nil) {
        dataController.save()
        widgetController.updateAllWidgets()
        
        if let item = item { qaController.update(item) }
    }
    
    // MARK: fetch requests
    func fetchRequestForTopItems(_ count: Int? = nil) -> NSFetchRequest<Item.CD> {
        dataController.fetchRequestForTopItems(count: count)
    }
    
    #if DEBUG
    func createSampleData() {
        objectWillChange.send()
        
        try? dataController.deleteAll()
        try? dataController.createSampleData()
    }
    #endif
    
}

// MARK: - (in app purchases)
extension AppState {
    
    var fullVersion: Bool { iapController.fullVersionUnlocked }
    var requestState: IAPController.RequestState { iapController.requestState }
    
    func restore() {
        iapController.restore()
    }
    
    func buy(_ product: SKProduct) {
        iapController.buy(product: product)
    }
    
}

// MARK: - (quick actions etc.)
extension AppState {
    
    func item(with id: String) -> Item? {
        guard
            let url = URL(string: id),
            let id = dataController.container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url),
            let cd = try? dataController.container.viewContext.existingObject(with: id) as? Item.CD
        else { return nil }
        
        return Item(cd)
    }
    
    func triggerQA() {
        guard let qa = qaController.checkQATriggered() else { return }
        
        switch qa {
        case .addProject: addProjectQA()
        }
    }
    
    func addProjectQA() {
        screen = .open
        addProject()
    }
    
}

// MARK: - (notifications)
extension AppState {
    
    func addReminders(for project: Project) async -> Bool {
        await notificationController.addReminders(for: project)
    }
    
    func removeReminders(for project: Project) async {
        await notificationController.removeReminders(for: project)
    }
    
}
