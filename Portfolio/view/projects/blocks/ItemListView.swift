//
//  ItemListView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 05.03.22.
//

import SwiftUI

struct ItemListView: View {
    
    let items: [Item]
    @ObservedObject var cd: Project.CDObject
    @EnvironmentObject var state: AppState
    
    let delete: ([Item], IndexSet) -> Void
    
    var body: some View {
        ForEach(items, id: \.self) { item in
            NavigationLink(destination: EditItemView(appState: state, item: item)) {
                Label {
                    Text(item.titleLabel)
                } icon: {
                    Image(systemName: item.icon.name)
                        .foregroundColor(item.icon.color)
                        .accessibilityLabel(item.icon.a11yLabel)
                }
            }
            .accessibilityLabel(~.navTitle(.editItem))
        }
        .onDelete { delete(items, $0) }
    }
    
    init(
        _ project: Project,
        sortOrder: Item.SortOrder,
        delete: @escaping ([Item], IndexSet) -> Void
    ) {
        cd = project.cd
        
        items = project.items.sorted(using: sortOrder)
        self.delete = delete
    }
    
}

// MARK: - (Previews)
struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView(.example, sortOrder: .optimized) {_, _ in}
    }
}
