//
//  model-previews.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 05.03.22.
//

import Foundation

// MARK: - (Projects)
extension Project {
    
    static var example = Project(
        in: DataController(inMemory: true).context,
        title: "Example Project",
        details: "This is an example project",
        colorID: .gold
    )
    
}

// MARK: - (Items)
extension Item {

    static var example = Item(
        in: DataController(inMemory: true).context,
        title: "Example Item",
        details: "This is an example item",
        priority: .high
    )

}

// MARK: - (Awards)
extension Award {
    
    static let example = allAwards[0]
    
}
