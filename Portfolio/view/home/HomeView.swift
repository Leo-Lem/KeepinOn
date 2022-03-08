//
//  HomeView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 04.03.22.
//

import SwiftUI
import MySwiftUI
import CoreSpotlight

struct HomeView: View {
    
    @EnvironmentObject var state: AppState
    var body: some View { Content(vm: ViewModel(appState: state)) }
    
    struct Content: View {
    
        @StateObject var vm: ViewModel
        
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
                
                if let item = vm.selectedItem { selectedItemNav(item) }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .onContinueUserActivity(CSSearchableItemActionType, perform: loadSpotlightItem)
            .group { $0
                .navigationTitle(~.navTitle(.home))
                #if DEBUG
                .toolbar {
                    Button("Add data") { vm.createSampleData() }
                }
                #endif
                .embedInNavigation()
            }
        }
        
    }
    
}

private extension HomeView.Content {
    
    func selectedItemNav(_ item: Item) -> some View {
        NavigationLink(
            destination: EditItemView(item: item),
            tag: item,
            selection: $vm.selectedItem,
            label: EmptyView.init
        )
        .id(item)
    }
    
    func loadSpotlightItem(_ userActivity: NSUserActivity) {
        if let id = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            vm.selectItem(with: id)
        }
    }
    
}

#if DEBUG
// MARK: - (Previews)
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AppState.preview)
    }
}
#endif
