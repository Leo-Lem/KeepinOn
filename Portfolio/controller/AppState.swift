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
        spotlightController: SpotlightController,
        notificationController: NotificationController,
        iapController: IAPController
    
    init(
        dataController: DataController? = nil,
        spotlightController: SpotlightController? = nil,
        notificationController: NotificationController? = nil,
        iapController: IAPController? = nil
    ) {
        self.dataController = dataController ?? .init()
        self.spotlightController = spotlightController ?? .init(dataController: self.dataController)
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
