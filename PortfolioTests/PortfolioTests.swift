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
    
    var state: AppState!
    var dc: DataController { state.dataController }
    var moc: NSManagedObjectContext { state.dataController.context }
    
    override func setUpWithError() throws {
        state = .init(dataController: .init(inMemory: true))
    }
    
}
