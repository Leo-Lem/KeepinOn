//
//  Layout.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 03.03.22.
//

import SwiftUI

//TODO: add bridge types for the coredata classes
extension Item {
    
    var titleLabel: String { title ?? (~.itemDefault).localize() }
    
}

extension Project {
    
    var titleLabel: String { title ?? (~.projDefault).localize() }
    var label: LocalizedStringKey {
        ~Strings.a11yDescription(project: titleLabel, items: projectItems.count, progress: completionAmount)
    }
    
}

extension Item {
    
    enum SortOrder {
        case optimized, title, creationDate
    }
    
}
