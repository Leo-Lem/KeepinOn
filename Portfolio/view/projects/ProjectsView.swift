//
//  ProjectsView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI
import CoreData

struct ProjectsView: View {
    
    let closed: Bool
    
    let cdProjects: FetchRequest<Project.CDObject>
    
    var body: some View {
        Content(
            closed: closed,
            projects: cdProjects.wrappedValue.map(Project.init),
            addProject: addProject,
            addItem: addItem,
            deleteItem: deleteItem
        )
    }
    
    @EnvironmentObject var dc: DataController
    
    init(closed: Bool) {
        self.closed = closed
        
        let request: NSFetchRequest<Project.CDObject> = Project.CDObject.fetchRequest()
        request.predicate = NSPredicate(format: "closed = %d", closed)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.CDObject.timestamp, ascending: false)]
        self.cdProjects = FetchRequest(fetchRequest: request)
    }
    
    func addProject() {
        _ = Project(in: dc.context)
        
        dc.save()
    }
    
    func addItem(to project: Project) {
        _ = Item(in: dc.context, project: project)
        
        dc.save()
    }
    
    func deleteItem(from items: [Item], at offsets: IndexSet) {
        offsets.forEach { offset in
            let item = items[offset]
            dc.delete(item)
        }
        
        dc.save()
    }
    
}
