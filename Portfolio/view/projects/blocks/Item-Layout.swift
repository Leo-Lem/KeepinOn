//
//  Item-Layout.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 05.03.22.
//

import SwiftUI

extension Item {
    
}

extension Array where Element == Item {
    
    func sorted(using sortOrder: Item.SortOrder) -> [Item] {
        switch sortOrder {
        case .title:
            return self.sorted {
                ($0.title ?? "_").localizedCaseInsensitiveCompare($1.title ?? "_") == .orderedAscending
            }
        case .timestamp:
            return self.sorted(by: \.timestamp, using: >)
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

extension Item {
    
    // swiftlint:disable:next large_tuple
    var icon: (
        name: String,
        color: Color,
        a11yLabel: LocalizedStringKey
    ) {
        if self.completed {
            return (
                "checkmark.circle",
                self.project?.colorID.color ?? Color("Light Blue"),
                ~.a11y(.completed(self.titleLabel))
            )
        } else if self.priority == .high {
            return (
                "exclamationmark.triangle",
                self.project?.colorID.color ?? Color("Light Blue"),
                ~.a11y(.priority(self.titleLabel))
            )
        } else {
            return (
                "checkmark.circle",
                .clear,
                LocalizedStringKey(self.titleLabel)
            )
        }
    }
    
}
