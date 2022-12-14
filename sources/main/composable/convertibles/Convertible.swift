// Created by Leopold Lemmermann on 18.12.22.

import ComposableArchitecture
import DatabaseService
import LeosMisc

struct Convertible<T: DatabaseObjectConvertible & Hashable>: ReducerProtocol {
  var service: any DatabaseService
  
  struct State: Equatable {
    var convertibles: IdentifiableSet<T>
    
    init(_ convertibles: [T] = []) { self.convertibles = IdentifiableSet(convertibles) }
    
    func convertible(with id: T.ID) -> T? { convertibles[id] }
    func convertibles(matching query: Query<T>) -> [T] { convertibles.filter(query.evaluate) }
  }
  
  enum Action {
    case insert(_ convertible: T?)
    case removeWith(id: T.ID)
    case add(_ convertible: T)
    case modifyWith(id: T.ID, modification: (inout T) async throws -> Void)
    case deleteWith(id: T.ID)
    case loadWith(id: T.ID)
    case loadFor(query: Query<T>)
    case reload
    case enableUpdates
  }

  // swiftlint:disable:next cyclomatic_complexity
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case let .insert(convertible):
      if let convertible, state.convertibles[convertible.id] != convertible {
        state.convertibles[convertible.id] = convertible
      }
    
    case let .removeWith(id) where state.convertibles[id] != nil:
      state.convertibles[id] = nil
    
    case let .add(convertible):
      return .task { .insert(try await service.insert(convertible)) }
    
    case let .modifyWith(id, modification):
      return .task { .insert(try await service.modify(T.self, with: id, modification: modification)) }
    
    case let .deleteWith(id):
      return .task {
        try await service.delete(T.self, with: id)
        return .removeWith(id: id)
      }
    
    case let .loadWith(id) where state.convertibles[id] == nil:
      return .task { .insert(try await service.fetch(with: id)) }
    
    case let .loadFor(query):
      return .run { actions in
        for try await convertibles in try await service.fetch(query) {
          for convertible in convertibles {
            await actions.send(.insert(convertible))
          }
        }
      }
      
    case .reload:
      let convertibles = state.convertibles
      return .run { actions in
        for id in convertibles.map(\.id) {
          if let newConvertible: T = try await service.fetch(with: id) {
            await actions.send(.insert(newConvertible))
          } else {
            await actions.send(.removeWith(id: id))
          }
        }
      }
      
    case .enableUpdates:
      return .run(priority: .background) { actions in
        for await event in service.events {
          if case .remote = event { await actions.send(.reload) }
        }
      }
      
    default: break
    }
    
    return .none
  }
}
