// Created by Leopold Lemmermann on 18.12.22.

import ComposableArchitecture

struct InAppPurchases: ReducerProtocol {
  @Dependency(\.inAppPurchaseService) private var service
  
  struct State: Equatable { var hasFullVersion: Bool }
  enum Action {
    case setHasFullVersion(Bool)
    case enableUpdates
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case let .setHasFullVersion(hasFullVersion): state.hasFullVersion = hasFullVersion
    case .enableUpdates:
      return .run(priority: .background) { actions in
        await actions.send(.setHasFullVersion(service.isPurchased(with: .fullVersion)))
        
        for await event in service.events {
          if case .purchased = event {
            await actions.send(.setHasFullVersion(service.isPurchased(with: .fullVersion)))
          }
        }
      }
    }
    
    return .none
  }
}
