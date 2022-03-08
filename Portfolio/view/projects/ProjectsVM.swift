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
    @MainActor final class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        
        private let state: AppState
        private let projectsController: NSFetchedResultsController<Project.CD>
        
        let closed: Bool
        var sortOrder: Item.SortOrder {
            get { state.itemSortOrder }
            set { state.itemSortOrder = newValue }
        }
        @Published var projects: [Project] = []
        @Published var unlocking = false
        
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
    
    func addProject() {
        guard
            state.iapController.fullVersionUnlocked || dc.count(for: Project.CD.fetchRequest()) < 3
        else { return unlocking = true }
        
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
            state.spotlightController.delete(item)
        }
        
        save()
    }
    
    private func save() { dc.save() }
    private var dc: DataController { state.dataController }
    
}

// MARK: - (CoreData)
extension ProjectsView.ViewModel {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let fetched = controller.fetchedObjects as? [Project.CD] {
            projects = fetched.map(Project.init)
        }
    }
    
    fileprivate static func projectsRequest(closed: Bool) -> NSFetchRequest<Project.CD> {
        let request: NSFetchRequest<Project.CD> = Project.CD.fetchRequest()
        
        request.predicate = NSPredicate(format: "closed = %d", closed)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.CD.timestamp, ascending: false)]
        
        return request
    }
    
}

// MARK: - (items)
extension Array where Element == Item {
    
    func sorted(using sortOrder: Item.SortOrder) -> [Item] {
        switch sortOrder {
        case .title:
            return self.sorted {
                ($0.title ?? "_").localizedCaseInsensitiveCompare($1.title ?? "_") == .orderedAscending
            }
        case .timestamp:
            return self.sorted(by: \.timestamp, using: >)
        case .optimized:
            return self.sorted { first, second in
                if !first.completed && second.completed {
                    return true
                } else if first.completed && !second.completed {
                    return false
                }

                if first.priority > second.priority {
                    return true
                } else if first.priority < second.priority {
                    return false
                }

                return first.timestamp < second.timestamp
            }
        }
    }

}
