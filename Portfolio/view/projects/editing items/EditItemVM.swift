//
//  EditItemVM.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import Foundation

extension EditItemView {
    @MainActor final class ViewModel: ObservableObject {
    
        private let state: AppState
        private let dismiss: () -> Void
        private var item: Item
        
        @Published var title: String
        @Published var details: String
        @Published var priority: Item.Priority
        @Published var completed: Bool
        let timestamp: Date
        
        init(
            appState: AppState,
            dismiss: @escaping () -> Void,
            item: Item
        ) {
            state = appState
            self.dismiss = dismiss
            
            self.item = item
            
            self.title = item.title ?? ""
            self.details = item.details
            self.priority = item.priority
            self.completed = item.completed
            self.timestamp = item.timestamp
        }
    
    }
}

extension EditItemView.ViewModel {
    
    func updateItem() {
        item.willChange()
        
        if !title.isEmpty { item.title = title }
        
        item.details = details
        item.priority = priority
        item.completed = completed
        
        state.save(item)
        
        dismiss()
    }
    
}
