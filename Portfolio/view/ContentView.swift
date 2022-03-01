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
                .tabItem { Label(Tab.home.rawValue, systemImage: "house") }
                
            ProjectsView(closed: false)
                .tag(Tab.open)
                .tabItem { Label(Tab.open.rawValue, systemImage: "list.bullet") }
                
            ProjectsView(closed: true)
                .tag(Tab.closed)
                .tabItem { Label(Tab.closed.rawValue, systemImage: "checkmark") }
        }
        #if DEBUG
        .navigationViewStyle(.stack) //for suppressing distracting warnings about the navigationtitle
        #endif
    }
}

extension ContentView {
    enum Tab: String {
        case home = "Home",
             open = "Open",
             closed = "Closed"
    }
}

#if DEBUG
//MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    private static let dataController = DataController.preview
    
    static var previews: some View {
        ContentView()
            .environment(
                \.managedObjectContext,
                 dataController.container.viewContext
            )
            .environmentObject(dataController)
    }
}
#endif
