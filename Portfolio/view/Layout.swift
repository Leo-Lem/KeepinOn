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
}
