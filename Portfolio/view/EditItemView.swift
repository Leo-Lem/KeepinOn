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
            Section("Basic Settings") {
                TextField("Item name", text: $title.onChange(update))
                TextField("Description", text: $details.onChange(update))
            }
            
            Section("Priority") {
                Picker("Priority", selection: $priority.onChange(update)) {
                    Text("Low").tag(1)
                    Text("Mid").tag(2)
                    Text("High").tag(3)
                }
                .pickerStyle(.segmented)
            }
            Section {
                Toggle("Mark Completed", isOn: $completed.onChange(update))
            }
        }
        .navigationTitle("Edit Item")
        .onDisappear { try? dataController.save() }
    }
    
    @State private var title: String
    @State private var details: String
    @State private var priority: Int
    @State private var completed: Bool
    
    init(_ item: Item) {
        self.item = item
        
        _title = State(initialValue: item.itemTitle)
        _details = State(initialValue: item.itemDetails)
        _priority = State(initialValue: Int(item.priority))
        _completed = State(initialValue: item.completed)
    }
    
    func update() {
        item.project?.objectWillChange.send()
        
        item.title = title
        item.details = details
        item.priority = Int16(priority)
        item.completed = completed
    }
    
}

#if DEBUG
//MARK: - Previews
struct EditItemView_Previews: PreviewProvider {
    private static let dataController: DataController = .preview
    
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
