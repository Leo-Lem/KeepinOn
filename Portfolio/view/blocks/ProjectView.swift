//
//  ProjectView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 03.03.22.
//

import SwiftUI

struct ProjectView: View {
    
    let sortOrder: Item.SortOrder,
        closed: Bool
    
    @ObservedObject var project: Project
    
    let addItem: (Project) -> Void,
        deleteItem: (Project, IndexSet) -> Void
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        
            ForEach(project.projectItems(using: sortOrder)) { item in
                ItemRowView(project: project, item: item)
            }
            .onDelete { deleteItem(project, $0) }
            
            if !closed {
                Button {
                    addItem(project)
                } label: {
                    Label(~.addItem, systemImage: "plus")
                }
            }
        
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView(sortOrder: .optimized, closed: true, project: .example) {_ in} deleteItem: {_, _ in}
    }
}
