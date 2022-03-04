//
//  Content.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 04.03.22.
//

import SwiftUI
import MySwiftUI

extension ProjectsView {
    struct Content: View {
        
        typealias AddProjectClosure = () -> Void // swiftlint:disable:this nesting
        typealias AddItemClosure = (Project) -> Void // swiftlint:disable:this nesting
        typealias DeleteItemClosure = ([Item], IndexSet) -> Void // swiftlint:disable:this nesting
        
        let closed: Bool
    
        let projects: [Project]
        
        let addProject: AddProjectClosure,
            addItem: AddItemClosure ,
            deleteItem: DeleteItemClosure

        var body: some View {
            List(projects) { project in
                let items = project.items.sorted(using: sortOrder)
                
                Section {
                    ForEach(items, content: ItemRowView.init)
                        .onDelete { deleteItem(items, $0) }
                    
                    if !closed {
                        Button {
                            addItem(project)
                        } label: {
                            Label(~.addItem, systemImage: "plus")
                        }
                    }
                } header: {
                    ProjectHeaderView(project)
                }
            }
            .listStyle(.insetGrouped)
            .replace(if: projects.count < 1, placeholder: ~.projPlaceholder)
            .navigationTitle(closed ? ~.closedProjs : ~.openProjs)
            .toolbar {
                addProjectToolbarItem
                sortOrderToolbarItem
            }
            .embedInNavigation {
                Text(~.emptyTabPlaceholder, font: .title2, color: .secondary)
            }
        }

        @SceneStorage("sortOrder") private var sortOrder: Item.SortOrder = .optimized
        
        init(
            closed: Bool,
            projects: [Project],
            addProject: @escaping AddProjectClosure,
            addItem: @escaping AddItemClosure,
            deleteItem: @escaping DeleteItemClosure
        ) {
            self.closed = closed
            self.projects = projects
            self.addProject = addProject
            self.addItem = addItem
            self.deleteItem = deleteItem
        }
        
    }
}

extension ProjectsView.Content {
    
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
// MARK: - (Previews)
// swiftlint:disable:next type_name
struct ProjectsView_Content_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView.Content(closed: false, projects: [.example]) {} addItem: {_ in} deleteItem: {_, _ in}
    }
}
#endif
