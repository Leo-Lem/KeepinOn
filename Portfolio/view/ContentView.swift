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
                .tabItem { Label(~.tab(.home), systemImage: "house") }
                
            ProjectsView(closed: false)
                .tag(Tab.open)
                .tabItem { Label(~.tab(.open), systemImage: "list.bullet") }
                
            ProjectsView(closed: true)
                .tag(Tab.closed)
                .tabItem { Label(~.tab(.closed), systemImage: "checkmark") }
            
            AwardsView()
                .tag(Tab.awards)
                .tabItem { Label(~.tab(.awards), systemImage: "rosette") }
        }
        #if DEBUG
        .navigationViewStyle(.stack)
        #endif
    }
    
    enum Tab: String {
        case home, open, closed, awards
    }
    
}

// MARK: - (Previews)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
