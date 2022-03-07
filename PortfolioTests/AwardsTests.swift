//
//  AwardsTests.swift
//  PortfolioTests
//
//  Created by Leopold Lemmermann on 05.03.22.
//

import XCTest
@testable import Portfolio
import CoreData
import MyCollections

class AwardsTests: BaseTestCase {
    
    let awards = Award.allAwards
    
    func testAwardIDMatchesName() {
        for award in awards {
            XCTAssertEqual(award.id, award.name,
                           "Award ID should always match its name.")
        }
    }
    
    func testNoAwards() throws {
        let vm = AwardsView.ViewModel(appState: state)
        
        for award in awards {
            XCTAssertEqual(vm.isUnlocked(award), false,
                           "New Users should have no awards unlocked.")
        }
    }
    
    func testItemAwards() throws {
        let vm = AwardsView.ViewModel(appState: state)
        
        for award in awards.filter({ $0.criterion == .items }) {
            addItems(award.value)
            defer { try? dc.deleteAll() }
            
            XCTAssertEqual(vm.isUnlocked(award), true,
                           "Award(value: \(award.value)) should be unlocked after adding the respective amount of items.")
            // swiftlint:disable:previous line_length
        }
        
        func addItems(_ n: Int) {
            for _ in 0..<n {
                _ = Item(in: moc)
            }
        }
    }
    
    func testCompleteAwards() throws {
        let vm = AwardsView.ViewModel(appState: state)
        
        for award in awards.filter({ $0.criterion == .complete }) {
            addItems(award.value)
            defer { try? dc.deleteAll() }
            
            XCTAssertEqual(vm.isUnlocked(award), true,
                           "Award(value: \(award.value)) should be unlocked after completing the respective amount of items.") // swiftlint:disable:this line_length
        }
        
        func addItems(_ n: Int) {
            for _ in 0..<n {
                var item = Item(in: moc)
                item.completed = true
            }
        }
    }
    
}
