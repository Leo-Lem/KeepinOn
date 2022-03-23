//
//  Award.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import Foundation
import MyData

struct Award: Decodable {

    let name: String,
        description: String,
        color: ColorID,
        criterion: Criterion,
        value: Int,
        image: String
    
}

extension Award: Identifiable { var id: String { name } }

extension Award {
    static let allAwards: [Award] = Bundle.main.load(optional: "Awards.json") ?? []
}

extension Award {
    enum Criterion {
        case items, complete, chat, unlock
        case unknown(_ value: String)
    }
}

extension Award.Criterion: Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        
        self = {
            switch string {
            case "items": return .items
            case "complete": return .complete
            case "chat": return .chat
            case "unlock": return .unlock
            default: return .unknown(string)
            }
        }()
    }
    
}

extension Award.Criterion: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        if case .unknown(let lhsValue) = lhs, case .unknown(let rhsValue) = rhs {
            return lhsValue == rhsValue
        } else {
            switch (lhs, rhs) {
            case (.items, .items), (.complete, .complete), (.chat, .chat), (.unlock, .unlock): return true
            default: return false
            }
        }
    }
    
}
