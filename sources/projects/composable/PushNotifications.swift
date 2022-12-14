// Created by Leopold Lemmermann on 18.12.22.

import ComposableArchitecture

struct PushNotifications: ReducerProtocol {
  @Dependency(\.pushNotificationService) private var service
  struct State: Equatable { var remindersAreAuthorized: Bool? }
  enum Action {
    case setRemindersAreAuthorized(Bool?)
    case authorizeReminders
    case enableUpdates
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case let .setRemindersAreAuthorized(areAuthorized):
      state.remindersAreAuthorized = areAuthorized
      
    case .authorizeReminders:
      switch state.remindersAreAuthorized {
      case nil: return .task { .setRemindersAreAuthorized(await service.authorize()) }
      case .some(false): openSystemSettings()
      case .some(true): break
      }
      
    case .enableUpdates:
      return .run(priority: .background) { actions in
        for await event in service.events {
          await actions.send(.setRemindersAreAuthorized(service.isAuthorized))
          
          if case let .authorization(isAuthorized) = event {
            await actions.send(.setRemindersAreAuthorized(isAuthorized))
          }
        }
      }
    }
    
    return .none
  }
}
