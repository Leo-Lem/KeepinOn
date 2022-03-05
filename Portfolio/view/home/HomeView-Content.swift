//
//  HomeView-Content.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 04.03.22.
//

import SwiftUI
import MySwiftUI

extension HomeView {
    struct Content: View {
        let projects: [Project],
            items: [Item]
        
        var body: some View {
            ScrollView {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: [GridItem(.fixed(100))]) {
                        ForEach(projects, content: ProjectSummaryView.init)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }

                VStack(alignment: .leading) {
                    ItemListView(title: ~.nextItems, items: items.prefix(3))
                    ItemListView(title: ~.moreItems, items: items.dropFirst(3))
                }
                .padding(.horizontal)
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle(~.navTitle(.home))
            .embedInNavigation()
        }
    }
}

#if DEBUG
// MARK: - (Previews)
// swiftlint:disable:next type_name
struct HomeView_Content_Previews: PreviewProvider {
    static var previews: some View {
        HomeView.Content(projects: [.example], items: [.example])
    }
}
#endif
