//
//  Project.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import CoreData

@objc(Project)
class Project: NSManagedObject {}

//MARK: - convenience extensions
extension Project {

    var projectDetails: String {
        details ?? ""
    }

    var projectColor: String {
        color ?? "Light Blue"
    }
    
    var projectItems: [Item] {
        items?.allObjects as? [Item] ?? []
    }
    
    func projectItems(using sortOrder: Item.SortOrder) -> [Item] {
        switch sortOrder {
        case .title: return projectItems.sorted { ($0.title ?? " ") < ($1.title ?? " ") }
        case .creationDate: return projectItems.sorted(by: \.itemTimestamp)
        case .optimized:
            return projectItems.sorted { first, second in
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
                
                return first.itemTimestamp < second.itemTimestamp
            }
        }
    }
    
    var completionAmount: Double {
        guard !projectItems.isEmpty else { return 0 }
        
        let completedItems = projectItems.filter(\.completed)
        return Double(completedItems.count) / Double(projectItems.count)
    }
    
    static let colors = ["Pink", "Purple", "Red", "Orange", "Gold", "Green", "Teal", "Light Blue", "Dark Blue", "Midnight", "Dark Gray", "Gray"]
    
}

//MARK: - Example
#if DEBUG
extension Project {
    
    static var example: Project {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let project = Project(context: viewContext)
        project.title = "Example Project"
        project.details = "This is an example project"
        project.closed = true
        project.timestamp = Date()
        return project
    }
    
}
#endif
