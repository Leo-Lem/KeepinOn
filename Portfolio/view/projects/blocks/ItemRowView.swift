//
//  ItemRowView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI

struct ItemRowView: View {
    
    let item: Item
    
    var body: some View {
        NavigationLink(destination: EditItemView(item: item)) {
            Label {
                Text(item.titleLabel)
            } icon: {
                Image(systemName: icon.name)
                    .foregroundColor(icon.color)
                    .accessibilityLabel(icon.a11yLabel)
            }
        }
    }
    
    @ObservedObject private var cd: Item.CDObject
    
    init(_ item: Item) {
        self.item = item
        cd = item.cd
    }
    
    // swiftlint:disable:next large_tuple
    private var icon: (
        name: String,
        color: Color,
        a11yLabel: LocalizedStringKey
    ) {
        if item.completed {
            return (
                "checkmark.circle",
                item.project?.color ?? Color("Light Blue"),
                Strings.a11yCompleted(project: item.titleLabel)
            )
        } else if item.priority == .high {
            return (
                "exclamationmark.triangle",
                item.project?.color ?? Color("Light Blue"),
                Strings.a11yPriority(project: item.titleLabel)
            )
        } else {
            return (
                "checkmark.circle", .clear, LocalizedStringKey(item.titleLabel)
            )
        }
    }
    
}

#if DEBUG
// MARK: - (Previews)
struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(.example)
    }
}
#endif
