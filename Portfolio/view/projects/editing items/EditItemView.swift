//
//  EditItemView-Content.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 04.03.22.
//

import SwiftUI

struct EditItemView: View {
    
    let item: Item
    @EnvironmentObject var state: AppState
    @Environment(\.dismiss) var dismiss
    
    var body: some View { Content(vm: ViewModel(appState: state, dismiss: { dismiss() }, item: item)) }
    
    struct Content: View {
    
        @StateObject var vm: ViewModel
        
        var body: some View {
            Form {
                Section(~.settings) {
                    TextField(~.itemNamePlaceholder, text: $vm.title)
                    TextField(~.itemDescPlaceholder, text: $vm.details)
                }
                
                Section(~.priority) {
                    Picker(~.priority, selection: $vm.priority, items: Item.Priority.allCases, id: \.self) { priority in
                        Text(~.priorityLevel(priority))
                            .tag(priority)
                    }
                    .pickerStyle(.segmented)
                }
                Section {
                    Toggle(~.markItemCompleted, isOn: $vm.completed)
                }
            }
            .navigationTitle(~.editItem)
            .toolbar {
                ToolbarItem { Button("Save") { vm.updateItem() } }
                ToolbarItem(placement: .bottomBar) { Text(vm.timestamp, format: .dateTime) }
            }
        }
        
    }
    
}

// MARK: - (Previews)
struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(item: .example)
            .environmentObject(AppState.preview)
    }
}
