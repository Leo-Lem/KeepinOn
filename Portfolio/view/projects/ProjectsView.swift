//
//  ProjectsView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 04.03.22.
//

import SwiftUI
import MySwiftUI

struct ProjectsView: View {

    var body: some View {
        List(vm.projects) { project in
            Section {
                ItemListView(project, sortOrder: vm.sortOrder, delete: vm.deleteItem)
                
                if !vm.closed {
                    Button { vm.addItem(to: project) } label: { Label(~.addItem, systemImage: "plus") }
                }
            } header: {
                ProjectHeaderView(project)
            }
        }
        .listStyle(.insetGrouped)
        .replace(if: vm.projects.count < 1, placeholder: ~.projPlaceholder)
        .navigationTitle(vm.closed ? ~.navTitle(.closed) : ~.navTitle(.open))
        .toolbar {
            addProjectToolbarItem
            sortOrderToolbarItem
        }
        .embedInNavigation {
            Text(~.emptyTabPlaceholder, font: .title2, color: .secondary)
        }
    }
        
    @StateObject private var vm: ViewModel
    
    init(appState: AppState, closed: Bool) {
        let vm = ViewModel(appState: appState, closed: closed)
        _vm = StateObject(wrappedValue: vm)
    }
        
}

extension ProjectsView {
    
    var addProjectToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if !vm.closed {
                Button(action: vm.addProject) {
                    Label(~.addProj, systemImage: "plus")
                }
            }
        }
    }
    
    var sortOrderToolbarItem: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarLeading) {
            Menu {
                ForEach(Item.SortOrder.allCases, id: \.self) { order in
                    Button(~.sortOrder(order)) { vm.sortOrder = order }
                }
            } label: {
                Label(~.sortOrder(vm.sortOrder), systemImage: "arrow.up.arrow.down")
                    .labelStyle(.titleAndIcon)
            }
        }
    }
    
}

// MARK: - (Previews)
struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView(appState: .preview, closed: false)
    }
}
