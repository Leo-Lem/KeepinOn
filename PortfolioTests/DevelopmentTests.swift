//
//  DevelopmentTests.swift
//  PortfolioTests
//
//  Created by Leopold Lemmermann on 05.03.22.
//

import XCTest
@testable import Portfolio
import CoreData

class DevelopmentTests: BaseTestCase {

    func testSampleDataCreationWorks() throws {
        try dc.createSampleData()
        
        XCTAssertEqual(
            dc.count(for: Project.CDObject.fetchRequest()), dc.exampleCount.projects,
            "There should be \(dc.exampleCount.projects) sample projects."
        )
        XCTAssertEqual(
            dc.count(for: Item.CDObject.fetchRequest()), dc.exampleCount.projects * dc.exampleCount.itemsPerProject,
            "There should be \(dc.exampleCount.projects * dc.exampleCount.itemsPerProject) sample items."
        )
    }
    
    func testDeleteAllClearsEverythingWithSampleData() throws {
        try dc.createSampleData()
        try dc.deleteAll()
        
        XCTAssertEqual(dc.count(for: Project.CDObject.fetchRequest()), 0,
                       "After deleting all, the database should contain no projects.")
        
        XCTAssertEqual(dc.count(for: Item.CDObject.fetchRequest()), 0,
                       "After deleting all, the database should contain no items.")
    }
    
    func testDeleteAllClearsEverything() throws {
        try dc.deleteAll()
        
        XCTAssertEqual(dc.count(for: Project.CDObject.fetchRequest()), 0,
                       "After deleting all, the database should contain no projects.")
        
        XCTAssertEqual(dc.count(for: Item.CDObject.fetchRequest()), 0,
                       "After deleting all, the database should contain no items.")
    }
    
    func testExampleProjectIsClosed() {
        let project: Project = .example
        XCTAssertFalse(project.closed, "The example project should be closed.")
    }

    func testExampleItemIsHighPriority() {
        let item: Item = .example
        XCTAssertEqual(item.priority, .high, "The example item should be high priority.")
    }
}
