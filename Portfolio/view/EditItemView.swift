//
//  EditItemView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI

struct EditItemView: View {
    
    @EnvironmentObject var dataController: DataController
    let item: Item
    
    var body: some View {
        Form {
            Section(~.settings) {
                TextField(~.itemNamePlaceholder, text: $title.onChange(update))
                TextField(~.itemDescPlaceholder, text: $details.onChange(update))
            }
            
            Section(~.priority) {
                Picker(~.priority, selection: $priority.onChange(update)) {
                    Text(~Strings.priorities.low).tag(1)
                    Text(~Strings.priorities.mid).tag(2)
                    Text(~Strings.priorities.high).tag(3)
                }
                .pickerStyle(.segmented)
            }
            Section {
                Toggle(~.markItemCompleted, isOn: $completed.onChange(update))
            }
        }
        .navigationTitle(~.editItem)
        .onDisappear { try? dataController.save() }
    }
    
    @State private var title: String
    @State private var details: String
    @State private var priority: Int
    @State private var completed: Bool
    
    init(_ item: Item) {
        self.item = item
        
        _title = State(initialValue: item.title ?? "")
        _details = State(initialValue: item.itemDetails)
        _priority = State(initialValue: Int(item.priority))
        _completed = State(initialValue: item.completed)
    }
    
    private func update() {
        item.project?.objectWillChange.send()
        
        item.title = title
        item.details = details
        item.priority = Int16(priority)
        item.completed = completed
    }
    
}

#if DEBUG
// MARK: - (Previews)
struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(.example)
            .environment(
                \.managedObjectContext,
                 dataController.container.viewContext
            )
            .environmentObject(dataController)
    }
}
#endif
