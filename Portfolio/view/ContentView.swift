//
//  ContentView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI
import MySwiftUI
import CoreSpotlight

struct ContentView: View {
    
    @EnvironmentObject var state: AppState
    
    var body: some View {
        TabView(selection: $state.screen) {
            ForEach(Tab.allCases, id: \.self) { tab in
                tab.view(state: state)
                    .tag(tab)
                    .tabItem { Label(~.tab(tab), systemImage: tab.icon) }
            }
        }
        .onContinueUserActivity(CSSearchableItemActionType) { _ in state.screen = .home }
        .onContinueUserActivity(.init(.addProject)) { _ in state.addProjectQA() }
        .userActivity(.init(.addProject)) { activity in
            activity.isEligibleForPrediction = true
            activity.title = (~.addProj).localize()
        }
        .onAppear(perform: state.appLaunched)
        #if DEBUG
        .navigationViewStyle(.stack)
        #endif
    }
    
}

extension ContentView.Tab {
    
    @ViewBuilder fileprivate func view(state: AppState) -> some View {
        switch self {
        case .home: HomeView()
        case .open: ProjectsView(closed: false)
        case .closed: ProjectsView(closed: true)
        case .awards: AwardsView()
        }
    }
    
    fileprivate var icon: String {
        switch self {
        case .home: return "house"
        case .open: return "list.bullet"
        case .closed: return "checkmark"
        case .awards: return "rosette"
        }
    }
    
}

// MARK: - (Previews)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState.preview)
    }
}
