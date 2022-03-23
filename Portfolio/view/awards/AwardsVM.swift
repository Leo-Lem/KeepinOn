//
//  AwardsVM.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI
import CoreData

extension AwardsView {
    @MainActor final class ViewModel: ObservableObject {
        
        private let state: AppState
        
        init(appState: AppState) {
            state = appState
        }
        
    }
}

extension AwardsView.ViewModel {
    
    func isUnlocked(_ award: Award) -> Bool {
        switch award.criterion {
        case .items:
            let fetchRequest = CDItem.fetchRequest()
            let count = state.count(for: fetchRequest)
            return count >= award.value
            
        case .complete:
            let fetchRequest = CDItem.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let count = state.count(for: fetchRequest)
            return count >= award.value
            
        case .unlock:
            return state.fullVersion
            
        default:
            return false // fatalError("Unknown award: \(award)")
        }
    }
    
}
