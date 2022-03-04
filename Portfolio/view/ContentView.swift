//
//  ContentView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI

struct ContentView: View {
    @SceneStorage("tab") private var tab: Tab = .home
    
    var body: some View {
        TabView(selection: $tab) {
            HomeView()
                .tag(Tab.home)
                .tabItem { Label(Tab.home.label, systemImage: "house") }
                
            ProjectsView(closed: false)
                .tag(Tab.open)
                .tabItem { Label(Tab.open.label, systemImage: "list.bullet") }
                
            ProjectsView(closed: true)
                .tag(Tab.closed)
                .tabItem { Label(Tab.closed.label, systemImage: "checkmark") }
            
            AwardsView()
                .tag(Tab.awards)
                .tabItem { Label(Tab.awards.label, systemImage: "rosette") }
        }
        #if DEBUG
        .navigationViewStyle(.stack)
        #endif
    }
}

extension ContentView {
    enum Tab: String {
        case home, open, closed, awards
        
        var label: LocalizedStringKey {
            switch self {
            case .home: return ~.home
            case .open: return ~.open
            case .closed: return ~.closed
            case .awards: return ~.awards
            }
        }
    }
}

#if DEBUG
// MARK: - (Previews)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
