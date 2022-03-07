//
//  ProjectsVM.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import Foundation
import CoreData
import MyOthers

extension ProjectsView {
    final class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        
        let closed: Bool
        
        var sortOrder: Item.SortOrder {
            get { state.itemSortOrder }
            set { state.itemSortOrder = newValue } // possibly insert objectWillChange publisher
        }
        
        @Published var projects: [Project] = []
        
        private let projectsController: NSFetchedResultsController<Project.CDObject>
        private let state: AppState
        
        init(appState: AppState, closed: Bool) {
            state = appState
            self.closed = closed
            
            projectsController = .init(
                fetchRequest: Self.projectsRequest(closed: closed),
                managedObjectContext: state.dataController.context,
                sectionNameKeyPath: nil, cacheName: nil
            )
            super.init()
            projectsController.delegate = self
            
            do {
                try projectsController.performFetch()
                projects ?= projectsController.fetchedObjects?.map(Project.init)
            } catch { print("Failed to fetch projects: \(error)") }
        }
        
    }
}

extension ProjectsView.ViewModel {
    
    private var dc: DataController { state.dataController }
    
    func addProject() {
        _ = Project(in: dc.context)
        
        save()
    }
    
    func addItem(to project: Project) {
        _ = Item(in: dc.context, project: project)
        
        save()
    }
    
    func deleteItem(from items: [Item], at offsets: IndexSet) {
        offsets.forEach { offset in
            let item = items[offset]
            dc.delete(item)
        }
        
        save()
    }
    
    private func save() { dc.save() }
    
}

// MARK: - (CoreData)
extension ProjectsView.ViewModel {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let fetched = controller.fetchedObjects as? [Project.CDObject] {
            projects = fetched.map(Project.init)
        }
    }
    
    fileprivate static func projectsRequest(closed: Bool) -> NSFetchRequest<Project.CDObject> {
        let request: NSFetchRequest<Project.CDObject> = Project.CDObject.fetchRequest()
        
        request.predicate = NSPredicate(format: "closed = %d", closed)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.CDObject.timestamp, ascending: false)]
        
        return request
    }
    
}
