//
//  PortfolioApp.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI

@main
struct PortfolioApp: App {
    
    @StateObject private var state = AppState()
    private var dc: DataController { state.dataController }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(state)
                // Automatically save when we detect that we are no longer the foreground app.
                // Use this rather than scene phase so we can port to macOS,
                // where scene phase won't detect our app losing focus.
                .onReceive(
                    NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
                ) { _ in dc.save() }
        }
    }
    
}
