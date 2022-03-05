//
//  AssetTests.swift
//  PortfolioTests
//
//  Created by Leopold Lemmermann on 05.03.22.
//

import XCTest
@testable import Portfolio

class AssetTests: XCTestCase {
    
    func testColorsExist() {
        for color in ColorID.allCases {
            XCTAssertNotNil(UIColor(named: color.rawValue), "Failed to load color '\(color)' from the asset catalog.")
        }
    }
    
    func testAwardsLoadCorrectly() {
        XCTAssertFalse(Award.allAwards.isEmpty, "Failed to load awards from JSON.")
    }
    
}
