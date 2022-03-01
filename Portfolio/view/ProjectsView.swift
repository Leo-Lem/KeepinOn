//
//  ProjectsView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI

struct ProjectsView: View {
    
    let closed: Bool,
        projects: FetchRequest<Project>
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        NavigationView {
            List {
                ForEach(projects.wrappedValue) { project in
                    Section {
                        ForEach(project.projectItems) { item in
                            ItemRowView(item: item)
                        }
                    } header: {
                        ProjectHeaderView(project: project)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("\(closed ? "Closed" : "Open") Projects")
            .toolbar {
                if !closed {
                    Button {
                        withAnimation {
                            let project = Project(context: context)
                            project.closed = false
                            project.timestamp = Date()
                            try? dataController.save()
                        }
                    } label: {
                        Label("Add project", systemImage: "plus")
                    }
                }
            }
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
    private static let dataController: DataController = .preview
    
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
