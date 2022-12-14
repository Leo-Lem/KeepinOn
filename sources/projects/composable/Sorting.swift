// Created by Leopold Lemmermann on 18.12.22.

import ComposableArchitecture

struct Sorting: ReducerProtocol {
  struct State: Equatable { var itemSortOrder: Item.SortOrder }
  enum Action { case setItemSortOrder(Item.SortOrder) }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case let .setItemSortOrder(sortOrder): state.itemSortOrder = sortOrder
    }
    
    return .none
  }
}
