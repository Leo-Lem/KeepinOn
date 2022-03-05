//
//  PortfolioTests.swift
//  PortfolioTests
//
//  Created by Leopold Lemmermann on 05.03.22.
//

import CoreData
import XCTest
@testable import Portfolio

class BaseTestCase: XCTestCase {
    
    var dc: DataController!
    var moc: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        dc = .init(inMemory: true)
        moc = dc.context
    }
    
}
