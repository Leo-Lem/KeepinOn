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
