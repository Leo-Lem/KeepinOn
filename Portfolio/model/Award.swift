//
//  Award.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import Foundation

struct Award: Decodable, Identifiable {
    
    var id: String { name }

    let name: String,
        description: String,
        color: String,
        criterion: String,
        value: Int,
        image: String

    static let allAwards: [Award] = Bundle.main.load(optional: "Awards.json") ?? []
    
}
