//
//  HomeView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 04.03.22.
//

import SwiftUI
import MySwiftUI

struct HomeView: View {
    
    var body: some View {
        ScrollView {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.fixed(100))]) {
                    ForEach(vm.projects, content: ProjectSummaryView.init)
                }
                .fixedSize(horizontal: false, vertical: true)
            }

            VStack(alignment: .leading) {
                PeekItemListView(title: ~.nextItems, items: vm.upNext)
                PeekItemListView(title: ~.moreItems, items: vm.moreToExplore)
            }
            .padding(.horizontal)
        }
        .background(Color.systemGroupedBackground.ignoresSafeArea())
        .navigationTitle(~.navTitle(.home))
        #if DEBUG
        .toolbar { Button("Add data", action: vm.createSampleData) }
        #endif
        .embedInNavigation()
    }
    
    @StateObject private var vm: ViewModel
    
    init(appState: AppState) {
        let vm = ViewModel(appState: appState)
        _vm = StateObject(wrappedValue: vm)
    }
    
}

#if DEBUG
// MARK: - (Previews)
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(appState: .preview)
    }
}
#endif
