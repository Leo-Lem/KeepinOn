//
//  ItemListView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 03.03.22.
//

import SwiftUI

extension HomeView {
    struct ItemList: View {
        let title: LocalizedStringKey,
            items: FetchedResults<Item>.SubSequence
        
        var body: some View {
            if !items.isEmpty {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.top)
                
                ForEach(items) { item in
                    NavigationLink {
                        EditItemView(item)
                    } label: {
                        HStack(spacing: 20) {
                            Circle()
                                .stroke(Color(item.project?.projectColor ?? "Light Blue"), lineWidth: 3)
                                .frame(width: 44, height: 44)

                            VStack(alignment: .leading) {
                                Text(item.titleLabel)
                                    .font(.title2)
                                    .foregroundColor(.primary)

                                if !item.itemDetails.isEmpty {
                                    Text(item.itemDetails)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.secondarySystemGroupedBackground)
                        .cornerRadius(10)
                        .shadow(color: .primary.opacity(0.2), radius: 5)
                    }
                }
            }
        }
    }
}
