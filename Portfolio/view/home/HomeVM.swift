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
    @MainActor class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        
        private let state: AppState
        private let projectsController: NSFetchedResultsController<Project.CD>
        private let itemsController: NSFetchedResultsController<Item.CD>
        
        @Published var selectedItem: Item?
        @Published var projects: [Project] = []
        @Published var items: [Item] = []
        
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
    
    func selectItem(with id: String) {
        selectedItem = state.qaController.item(with: id)
    }
    
}

// MARK: - (CoreData)
extension HomeView.ViewModel {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let fetched = controller.fetchedObjects as? [Project.CD] {
            projects = fetched.map(Project.init)
        } else if let fetched = controller.fetchedObjects as? [Item.CD] {
            items = fetched.map(Item.init)
        }
    }
    
    fileprivate static let projectsRequest: NSFetchRequest<Project.CD> = {
        let request: NSFetchRequest<Project.CD> = Project.CD.fetchRequest()
        
        request.predicate = NSPredicate(format: "closed = false")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.CD.title, ascending: true)]
            
        return request
    }()
    
    fileprivate static let itemsRequest: NSFetchRequest<Item.CD> = {
        let request: NSFetchRequest<Item.CD> = Item.CD.fetchRequest()
        
        let completedPredicate = NSPredicate(format: "completed = false"),
            openPredicate = NSPredicate(format: "project.closed = false")
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.CD.priority, ascending: false)]
        request.fetchLimit = 10
        
        return request
    }()
    
    #if DEBUG
    func createSampleData() {
        state.objectWillChange.send()
        
        try? state.dataController.deleteAll()
        try? state.dataController.createSampleData()
    }
    #endif
    
}
