//
//  ContentView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var state: AppState
    
    var body: some View {
        TabView(selection: $state.screen) {
            ForEach(Tab.displayedTabs, id: \.self) { $0.view(state: state) }
        }
        #if DEBUG
        .navigationViewStyle(.stack)
        #endif
    }
    
}

extension ContentView.Tab {
    
    fileprivate static let displayedTabs: [Self] = [.home, .open, .closed, .awards]
    
    fileprivate func view(state: AppState) -> some View {
        Group {
            switch self {
            case .home: HomeView(appState: state)
            case .open: ProjectsView(appState: state, closed: false)
            case .closed: ProjectsView(appState: state, closed: true)
            case .awards: AwardsView(appState: state)
            default: EmptyView()
            }
        }
        .tag(self)
        .tabItem { Label(~.tab(self), systemImage: self.icon) }
    }
    
    private var icon: String {
        switch self {
        case .home: return "house"
        case .open: return "list.bullet"
        case .closed: return "checkmark"
        case .awards: return "rosette"
        default: return "questionmark"
        }
    }
    
}

// MARK: - (Previews)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DataController.preview)
            .environmentObject(AppState())
    }
}
