//
//  AppState.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 05.03.22.
//

import Foundation
import StoreKit

final class AppState: ObservableObject {
    
    @Published var screen: ContentView.Tab = .home
    @Published var itemSortOrder: Item.SortOrder = .optimized
    
    let dataController: DataController,
        qaController: QAController,
        notificationController: NotificationController,
        iapController: IAPController
    
    init(
        dataController: DataController? = nil,
        qaController: QAController? = nil,
        notificationController: NotificationController? = nil,
        iapController: IAPController? = nil
    ) {
        self.dataController = dataController ?? .init()
        self.qaController = qaController ?? .init(dataController: self.dataController)
        self.notificationController = notificationController ?? .init()
        self.iapController = iapController ?? .init()
    }
    
    func appLaunched() {
        guard dataController.count(for: Project.CD.fetchRequest()) >= 5 else { return }
        
        let allScenes = UIApplication.shared.connectedScenes
        let scene = allScenes.first { $0.activationState == .foregroundActive }
        
        if let windowScene = scene as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
}

extension AppState {
    
    @discardableResult func addProject() -> Bool {
        let canCreate = iapController.fullVersionUnlocked || dataController.count(for: Project.CD.fetchRequest()) < 3
        
        if canCreate { dataController.createProject() }
        
        return canCreate
    }
    
}

// MARK: - Quick Actions etc.
extension AppState {
    
    func triggerQA() {
        guard let qa = qaController.checkQATriggered() else { return }
        
        switch qa {
        case .addProject: addProjectQA()
        }
    }
    
    func addProjectQA() {
        screen = .open
        addProject()
    }
    
}

extension ContentView {
    
    enum Tab: String, CaseIterable {
        case home, open, closed, awards
    }
    
}

extension Item {
    
    enum SortOrder: String, CaseIterable {
        case optimized, title, timestamp
    }
    
}
