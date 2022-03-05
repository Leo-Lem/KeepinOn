//
//  AwardsView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI
import CoreData

struct AwardsView: View {
    
    var body: some View { Content(unlocked: unlocked) }
    
    @EnvironmentObject var dc: DataController
    
    func unlocked(_ award: Award) -> Bool { dc.isUnlocked(award) }
    
}

extension DataController {
    
    func isUnlocked(_ award: Award) -> Bool {
        switch award.criterion {
        case .items:
            let fetchRequest = CDItem.fetchRequest()
            let count = count(for: fetchRequest)
            return count >= award.value
            
        case .complete:
            let fetchRequest = CDItem.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let count = count(for: fetchRequest)
            return count >= award.value
            
        default:
            return false // fatalError("Unknown award: \(award)")
        }
    }
    
}
