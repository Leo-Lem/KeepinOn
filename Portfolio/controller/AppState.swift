//
//  AppState.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 05.03.22.
//

import Foundation

final class AppState: ObservableObject {
    
    @Published var screen: ContentView.Tab = .home
    @Published var itemSortOrder: Item.SortOrder = .optimized
    
    let dataController: DataController
    
    init(
        dataController: DataController = .init()
    ) {
        self.dataController = dataController
    }
    
}

extension ContentView {
    
    enum Tab: String {
        case home, open, closed, awards, editProj, editItem
    }
    
}

extension Item {
    
    enum SortOrder: String, CaseIterable {
        case optimized, title, timestamp
    }
    
}
