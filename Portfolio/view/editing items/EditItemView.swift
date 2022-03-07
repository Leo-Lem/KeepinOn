//
//  EditItemView-Content.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 04.03.22.
//

import SwiftUI

struct EditItemView: View {
    
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
        .navigationTitle(~.navTitle(.editItem))
        .toolbar {
            ToolbarItem {
                Button("Save") {
                    vm.updateItem()
                    dismiss()
                }
            }
            ToolbarItem(placement: .bottomBar) { Text(vm.timestamp, format: .dateTime) }
        }
    }
    
    @StateObject private var vm: ViewModel
    
    init(appState: AppState, item: Item) {
        let vm = ViewModel(appState: appState, item: item)
        _vm = StateObject(wrappedValue: vm)
    }
    
    @Environment(\.dismiss) var dismiss
}

// MARK: - (Previews)
struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(appState: .preview, item: .example)
    }
}
