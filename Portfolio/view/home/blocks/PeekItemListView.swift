//
//  PeekItemListView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 03.03.22.
//

import SwiftUI
import MySwiftUI

struct PeekItemListView: View {
    
    @EnvironmentObject var state: AppState
    
    let title: LocalizedStringKey,
        items: Array<Item>.SubSequence
    
    var body: some View {
        if !items.isEmpty {
            Text(title, font: .headline, color: .secondary)
                .padding(.top)
            
            ForEach(items) { item in
                NavigationLink(destination: EditItemView(appState: state, item: item)) { Row(item) }
            }
        }
    }
    
    struct Row: View {
        let item: Item
        @ObservedObject private var cd: Item.CDObject
        
        var body: some View {
            HStack(spacing: 20) {
                Circle()
                    .stroke(item.project?.colorID.color ?? Color("Light Blue"), lineWidth: 3)
                    .frame(width: 20, height: 20)

                VStack(alignment: .leading) {
                    Text(item.titleLabel, font: .title2, color: .primary)

                    if !item.details.isEmpty { Text(item.details, color: .secondary) }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.secondarySystemGroupedBackground)
            .cornerRadius(10)
            .shadow(color: .primary.opacity(0.2), radius: 5)
        }
        
        init(_ item: Item) {
            self.item = item
            cd = item.cd
        }
    }
    
}

#if DEBUG
// MARK: - (Previews)
struct PeekItemListView_Previews: PreviewProvider {
    static var previews: some View {
        PeekItemListView(title: "My Items", items: [.example])
    }
}
#endif
