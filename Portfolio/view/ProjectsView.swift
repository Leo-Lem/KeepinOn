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
                        ForEach(project.projectItems(using: sortOrder)) { item in
                            ItemRowView(project: project, item: item)
                        }
                        .onDelete { offsets in
                            let items = project.projectItems(using: sortOrder)
                            
                            offsets.forEach { offset in
                                let item = items[offset]
                                dataController.delete(item)
                            }
                            
                            try? dataController.save()
                        }
                        
                        if !closed {
                            Button {
                                withAnimation {
                                    let item = Item(context: context)
                                    item.project = project
                                    item.timestamp = Date()
                                    try? dataController.save()
                                }
                            } label: {
                                Label("Add New Item", systemImage: "plus")
                            }                        }
                    } header: {
                        ProjectHeaderView(project: project)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .replace(if: projects.wrappedValue.count < 1, placeholder: "There's nothing here right now.")
            .navigationTitle("\(closed ? "Closed" : "Open") Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
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
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        sorting.toggle()
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
            .confirmationDialog("Sort items", isPresented: $sorting) {
                Button("Optimized") { sortOrder = .optimized }
                Button("Creation Date") { sortOrder = .creationDate }
                Button("Title") { sortOrder = .title }
            }
            
            SelectSomethingView()
        }
    }
    
    @State private var sorting = false
    @State private var sortOrder: Item.SortOrder = .optimized
    
    init(closed: Bool) {
        self.closed = closed
        
        projects = FetchRequest<Project>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Project.timestamp, ascending: false)],
            predicate: NSPredicate(format: "closed = %d", closed)
        )
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
