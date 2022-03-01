//
//  ContentView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView().tabItem { Label("Home", systemImage: "house") }
            
            ProjectsView(closed: false).tabItem { Label("Open", systemImage: "list.bullet") }
            
            ProjectsView(closed: true).tabItem { Label("Closed", systemImage: "checkmark") }
        }
        #if DEBUG
        .navigationViewStyle(.stack)
        #endif
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
