//
//  ItemRowView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI

struct ItemRowView: View {
    @ObservedObject var item: Item
    
    var body: some View {
        NavigationLink {
            EditItemView(item)
        } label: {
            Text(item.itemTitle)
        }
    }
}

#if DEBUG
//MARK: - Previews
struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(item: .example)
    }
}
#endif
