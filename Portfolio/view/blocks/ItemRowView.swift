//
//  ItemRowView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI

struct ItemRowView: View {
    
    @ObservedObject var project: Project
    @ObservedObject var item: Item
    
    var body: some View {
        NavigationLink {
            EditItemView(item)
        } label: {
            Label(title: {
                Text(item.titleLabel)
            }, icon: icon)
                .accessibilityLabel(label)
        }
    }
    
    private func icon() -> some View {
        if item.completed {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(Color(project.projectColor))
        } else if item.priority == 3 {
            return Image(systemName: "exclamationmark.triangle")
                .foregroundColor(Color(project.projectColor))
        } else {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(.clear)
        }
    }
    
    var label: Text {
        if item.completed {
            return Text("\(item.titleLabel), completed.")
        } else if item.priority == 3 {
            return Text("\(item.titleLabel), high priority.")
        } else {
            return Text(item.titleLabel)
        }
    }
    
}

#if DEBUG
//MARK: - Previews
struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(project: .example, item: .example)
    }
}
#endif
