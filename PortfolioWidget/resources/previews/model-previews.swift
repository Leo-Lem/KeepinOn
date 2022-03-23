//
//  model-previews.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 14.03.22.
//

import Foundation

// MARK: - (Projects)
extension Project {
    
    static var example = Project(
        in: DataController.preview.container.viewContext,
        title: "Example Project",
        details: "This is an example project",
        colorID: .gold
    )
    
}

// MARK: - (Items)
extension Item {

    static var example = Item(
        in: DataController.preview.container.viewContext,
        title: "Example Item",
        details: "This is an example item",
        priority: .high
    )

}
