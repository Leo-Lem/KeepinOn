//
//  ProjectsView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI
import CoreData

struct ProjectsView: View {
    
    let closed: Bool,
        projects: FetchRequest<Project>
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        NavigationView {
            List(projects.wrappedValue) { project in
                Section {
                    ProjectView(
                        sortOrder: sortOrder,
                        closed: closed,
                        project: project,
                        addItem: addItem,
                        deleteItem: deleteItem
                    )
                } header: {
                    ProjectHeaderView(project: project)
                }
            }
            .replace(if: projects.wrappedValue.count < 1, placeholder: ~.projPlaceholder)
            .listStyle(.insetGrouped)
            .navigationTitle(closed ? ~.closedProjs : ~.openProjs)
            .toolbar {
                addProjectToolbarItem
                sortOrderToolbarItem
            }
            
            SelectSomethingView()
        }
    }
    
    @State private var sortOrder: Item.SortOrder = .optimized
    
    init(closed: Bool) {
        self.closed = closed
        self.projects = FetchRequest(fetchRequest: ProjectsView.projectRequest(closed: closed))
    }
    
}

private extension ProjectsView {
    
    static func projectRequest(closed: Bool) -> NSFetchRequest<Project> {
        let request: NSFetchRequest<Project> = Project.fetchRequest()
        request.predicate = NSPredicate(format: "closed = %d", closed)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.timestamp, ascending: false)]
        
        return request
    }
    
    func addProject() {
        withAnimation {
            let project = Project(context: context)
            project.closed = false
            project.timestamp = Date()
            try? dataController.save()
        }
    }
    
    func addItem(to project: Project) {
        withAnimation {
            let item = Item(context: context)
            item.project = project
            item.timestamp = Date()
            try? dataController.save()
        }
    }
    
    func deleteItem(
        from project: Project,
        at offsets: IndexSet
    ) {
        let items = project.projectItems(using: sortOrder)
        
        offsets.forEach { offset in
            let item = items[offset]
            dataController.delete(item)
        }
        
        try? dataController.save()
    }
    
}

extension ProjectsView {
    var addProjectToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if !closed {
                Button(action: addProject) {
                    Label(~.addProj, systemImage: "plus")
                }
            }
        }
    }
    
    var sortOrderToolbarItem: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarLeading) {
            Menu {
                Button(~.optimizedSort) { sortOrder = .optimized }
                Button(~.creationDateSort) { sortOrder = .creationDate }
                Button(~.titleSort) { sortOrder = .title }
            } label: {
                Label(~.sortLabel, systemImage: "arrow.up.arrow.down")
            }
        }
    }
}

#if DEBUG
//MARK: - Previews
struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProjectsView(closed: false)
            ProjectsView(closed: true)
        }
        .environmentObject(dataController)
        .environment(
            \.managedObjectContext,
             dataController.container.viewContext
        )
    }
}
#endif 
