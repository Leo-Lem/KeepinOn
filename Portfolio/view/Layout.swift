//
//  Layout.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 03.03.22.
//

import SwiftUI
import MySwiftUI

extension ColorID {
    
    var color: Color { Color(self.rawValue) }
    
}

// MARK: - (Projects)
extension Project {
    
    var titleLabel: String { title ?? (~.projDefault).localize() }

    var a11yLabel: LocalizedStringKey {
        ~.a11y(.description(titleLabel, count: items.count, progress: progress))
    }
    
}

// MARK: - (Items)
extension Item {
    
    var titleLabel: String { title ?? (~.itemDefault).localize() }
    
    enum SortOrder: String { case optimized, title, timestamp }
    
}

extension Array where Element == Item {

    mutating func sort(using sortOrder: Item.SortOrder) {
        self = self.sorted(using: sortOrder)
    }

    func sorted(using sortOrder: Item.SortOrder) -> [Item] {
        switch sortOrder {
        case .title:
            return self.sorted { ($0.title ?? " ") < ($1.title ?? " ") }
        case .timestamp:
            return self.sorted(by: \.timestamp)
        case .optimized:
            return self.sorted { first, second in
                if !first.completed && second.completed {
                    return true
                } else if first.completed && !second.completed {
                    return false
                }

                if first.priority > second.priority {
                    return true
                } else if first.priority < second.priority {
                    return false
                }

                return first.timestamp < second.timestamp
            }
        }
    }

}

// MARK: - (Awards)
