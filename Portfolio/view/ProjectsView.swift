//
//  ProjectsView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI

struct ProjectsView: View {
    let closed: Bool
    let projects: FetchRequest<Project>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(projects.wrappedValue) { project in
                    Section(project.title ?? "") {
                        ForEach(project.items?.allObjects as? [Item] ?? []) { item in
                            Text(item.title ?? "")
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("\(closed ? "Closed" : "Open") Projects")
        }
    }
    
    init(closed: Bool) {
        self.closed = closed
        
        projects = FetchRequest<Project>(
            entity: Project.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Project.timestamp, ascending: false)],
            predicate: NSPredicate(format: "closed = %d", closed)
        )
    }
    
}

#if DEBUG
//MARK: - Previews
struct ProjectsView_Previews: PreviewProvider {
    private static let dataController = DataController.preview
    
    static var previews: some View {
        ProjectsView(closed: true)
            .environment(
                \.managedObjectContext,
                 dataController.container.viewContext
            )
        
        ProjectsView(closed: false)
            .environment(
                \.managedObjectContext,
                 dataController.container.viewContext
            )
    }
}
#endif
