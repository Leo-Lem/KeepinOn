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
    
    @Environment(\.scenePhase) private var scenePhase
    
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
                // Checks if any shortcut items have been triggered before scene activation.
                .onChange(of: scenePhase) { phase in
                    if case .active = phase { state.triggerQA() }
                }
        }
    }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
}

// MARK: - (delegates)
final class AppDelegate: NSObject, UIApplicationDelegate {
    
    static var shortcutItem: UIApplicationShortcutItem?
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        if let shortcutItem = options.shortcutItem { Self.shortcutItem = shortcutItem }
        
        let sceneConfiguration = UISceneConfiguration(name: "Default", sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = SceneDelegate.self
        
        return sceneConfiguration
    }
    
    private final class SceneDelegate: NSObject, UIWindowSceneDelegate {
        
        func windowScene(
            _ windowScene: UIWindowScene,
            performActionFor shortcutItem: UIApplicationShortcutItem,
            completionHandler: @escaping (Bool) -> Void
        ) {
            AppDelegate.shortcutItem = shortcutItem
        }
        
    }
    
}
