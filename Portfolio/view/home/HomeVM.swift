//
//  HomeVM.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import Foundation
import CoreData
import MyOthers

extension HomeView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        
        @Published var projects: [Project] = []
        @Published var items: [Item] = []
        
        private let projectsController: NSFetchedResultsController<Project.CDObject>
        private let itemsController: NSFetchedResultsController<Item.CDObject>
        
        private let state: AppState
        private var dc: DataController { state.dataController }
        
        init(appState: AppState) {
            state = appState
            
            projectsController = .init(
                fetchRequest: Self.projectsRequest,
                managedObjectContext: state.dataController.context,
                sectionNameKeyPath: nil, cacheName: nil
            )
            itemsController = .init(
                fetchRequest: Self.itemsRequest,
                managedObjectContext: state.dataController.context,
                sectionNameKeyPath: nil, cacheName: nil
            )
            super.init()
            projectsController.delegate = self
            itemsController.delegate = self
            
            do {
                try projectsController.performFetch()
                try itemsController.performFetch()
                
                projects ?= projectsController.fetchedObjects?.map(Project.init)
                items ?= itemsController.fetchedObjects?.map(Item.init)
            } catch { print("Failed to fetch projects and/or items: \(error)") }
        }
        
    }
}

extension HomeView.ViewModel {
    
    var upNext: ArraySlice<Item> { items.prefix(3) }
    var moreToExplore: ArraySlice<Item> { items.dropFirst(3) }
    
}

// MARK: - (CoreData)
extension HomeView.ViewModel {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let fetched = controller.fetchedObjects as? [Project.CDObject] {
            projects = fetched.map(Project.init)
        } else if let fetched = controller.fetchedObjects as? [Item.CDObject] {
            items = fetched.map(Item.init)
        }
    }
    
    fileprivate static let projectsRequest: NSFetchRequest<Project.CDObject> = {
        let request: NSFetchRequest<Project.CDObject> = Project.CDObject.fetchRequest()
        
        request.predicate = NSPredicate(format: "closed = false")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.CDObject.title, ascending: true)]
            
        return request
    }()
    
    fileprivate static let itemsRequest: NSFetchRequest<Item.CDObject> = {
        let request: NSFetchRequest<Item.CDObject> = Item.CDObject.fetchRequest()
        
        let completedPredicate = NSPredicate(format: "completed = false"),
            openPredicate = NSPredicate(format: "project.closed = false")
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.CDObject.priority, ascending: false)]
        request.fetchLimit = 10
        
        return request
    }()
    
    #if DEBUG
    func createSampleData() { try? dc.createSampleData() }
    #endif
    
}
