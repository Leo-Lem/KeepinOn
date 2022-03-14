//
//  ProjectsView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 04.03.22.
//

import SwiftUI
import MySwiftUI

struct ProjectsView: View {
    
    let closed: Bool
    @EnvironmentObject var state: AppState
    var body: some View { Content(vm: ViewModel(appState: state, closed: closed)) }
    
    struct Content: View {

        @StateObject var vm: ViewModel
        
        var body: some View {
            List(vm.projects) { project in
                Section {
                    ItemListView(project, sortOrder: vm.sortOrder) { vm.deleteItem(from: $0, at: $1) }
                    
                    if !vm.closed {
                        Button { vm.addItem(to: project) } label: { Label(~.addItem, systemImage: "plus") }
                            .foregroundColor(project.colorID.color)
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
            .sheet(isPresented: $vm.unlocking, content: UnlockView.init)
        }
        
    }
    
}

private extension ProjectsView.Content {
    
    var addProjectToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if !vm.closed {
                Button {
                    vm.addProject()
                } label: {
                    Label(~.addProj, systemImage: "plus")
                }
            }
        }
    }
    
    var sortOrderToolbarItem: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarLeading) {
            Menu {
                Text(~.sortOrder(vm.sortOrder), font: .headline)
                ForEach(Item.SortOrder.allCases, id: \.self) { order in
                    Button(~.sortOrder(order)) { vm.sortOrder = order }
                }
            } label: {
                Label(~.sortOrder(vm.sortOrder), systemImage: "arrow.up.arrow.down")
            }
        }
    }
    
}

// MARK: - (Previews)
struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView(closed: false)
            .environmentObject(AppState.preview)
    }
}
