//
//  EditItemView-Content.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 04.03.22.
//

import SwiftUI

extension EditItemView {
    struct Content: View {
        
        typealias UpdateClosure = (String, String, Item.Priority, Bool) -> Void // swiftlint:disable:this nesting
        
        let updateItem: UpdateClosure
        
        var body: some View {
            Form {
                Section(~.settings) {
                    TextField(~.itemNamePlaceholder, text: $title.onChange(update))
                    TextField(~.itemDescPlaceholder, text: $details.onChange(update))
                }
                
                Section(~.priority) {
                    Picker(
                        ~.priority, selection: $priority.onChange(update), items: Item.Priority.allCases, id: \.self
                    ) { priority in
                        Text(Strings.priority(priority)).tag(priority)
                    }
                    .pickerStyle(.segmented)
                }
                Section {
                    Toggle(~.markItemCompleted, isOn: $completed.onChange(update))
                }
            }
            .navigationTitle(~.editItem)
        }
        
        @State private var title: String
        @State private var details: String
        @State private var priority: Item.Priority
        @State private var completed: Bool
        
        init(
            _ item: Item,
            update: @escaping UpdateClosure
        ) {
            self.updateItem = update
            
            _title = State(initialValue: item.title ?? "")
            _details = State(initialValue: item.details)
            _priority = State(initialValue: item.priority)
            _completed = State(initialValue: item.completed)
        }
        
        private func update() { updateItem(title, details, priority, completed) }
        
    }
}

#if DEBUG
// MARK: - (Previews)
// swiftlint:disable:next type_name
struct EditItemView_Content_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView.Content(.example) {_, _, _, _ in}
    }
}
#endif
