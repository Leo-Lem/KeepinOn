// Created by Leopold Lemmermann on 23.02.25.

import ComposableArchitecture
import Data

@Reducer public struct ItemEdit {
  @ObservableState public struct State: Equatable {
    public var item: Item

    public init(_ item: Item) { self.item = item }
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding(\.item):
        try? database.write {
          try state.item.save($0)
        }
        return .none

      case .binding:
        return .none
      }
    }
  }

  @Dependency(\.defaultDatabase) var database

  public init() {}
}
