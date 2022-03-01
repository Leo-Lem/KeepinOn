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
                Text(item.itemTitle)
            }, icon: icon)
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
    
}

#if DEBUG
//MARK: - Previews
struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(project: .example, item: .example)
    }
}
#endif
