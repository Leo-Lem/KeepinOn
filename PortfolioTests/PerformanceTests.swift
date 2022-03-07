//
//  PerformanceTests.swift
//  PortfolioTests
//
//  Created by Leopold Lemmermann on 05.03.22.
//

import XCTest
@testable import Portfolio

class PerformanceTests: BaseTestCase {

    func testAwardCalculationPerformance() throws {
        let vm = AwardsView.ViewModel(appState: state)
        
        // Create a significant amount of test data
        for _ in 0..<100 {
            try dc.createSampleData()
        }
        // Simulate lots of awards to check
        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        XCTAssertEqual(awards.count, 500,
                       "This checks the awards count is constant. Change this if you add awards.")
        
        measure {
            _ = awards.filter(vm.isUnlocked)
        }
    }

}
