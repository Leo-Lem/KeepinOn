//
//  ProjectTests.swift
//  PortfolioTests
//
//  Created by Leopold Lemmermann on 05.03.22.
//

import XCTest
@testable import Portfolio
import CoreData

class ProjectTests: BaseTestCase {

    func testCreatingProjectsAndItems() {
        let targetCount = 10
        
        for _ in 0..<targetCount {
            let project = Project(in: moc)
            
            for _ in 0..<targetCount {
                _ = Item(in: moc, project: project)
            }
        }
        
        XCTAssertEqual(dc.count(for: Project.CDObject.fetchRequest()), targetCount)
        XCTAssertEqual(dc.count(for: Item.CDObject.fetchRequest()), targetCount * targetCount)
    }

    func testDeletingProjectCascadeDeletesItems() throws {
        try dc.createSampleData()
        
        let request: NSFetchRequest<Project.CDObject> = Project.CDObject.fetchRequest()
        let projects = (try moc.fetch(request)).map(Project.init)
        
        dc.delete(projects[0])
        
        let remainingProjectCount = dc.exampleCount.projects - 1
        XCTAssertEqual(dc.count(for: Project.CDObject.fetchRequest()), remainingProjectCount)
        XCTAssertEqual(
            dc.count(for: Item.CDObject.fetchRequest()), dc.exampleCount.itemsPerProject * remainingProjectCount
        )
    }
    
}
