//
//  EditItemVM.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI
import MySwiftUI

extension EditItemView {
    final class ViewModel: ObservableObject {
    
        @Published var title: String
        @Published var details: String
        @Published var priority: Item.Priority
        @Published var completed: Bool
        
        let timestamp: Date
        
        private var item: Item
        
        private let state: AppState
        private var dc: DataController { state.dataController }
        
        init(appState: AppState, item: Item) {
            state = appState
            
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
        item.update()
        
        if !title.isEmpty { item.title = title }
        
        item.details = details
        item.priority = priority
        item.completed = completed
        
        save()
    }
    
    private func save() { dc.save() }
    
}
