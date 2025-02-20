// Created by Leopold Lemmermann on 20.02.25.

import ComposableArchitecture
import Data

@Reducer public struct EditableItem {
  @ObservableState public struct State: Equatable, Identifiable {
    public var item: Item

    public var id: PersistentIdentifier { item.id }

    public init(_ item: Item) { self.item = item }
  }

  public enum Action {
    case delete
    case toggle
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .delete:
        return .run { [delete, item = state.item] _ in
          try await delete(item)
        }

      case .toggle:
        state.item.done.toggle()
        return .none
      }
    }
  }

  @Dependency(\.items.delete) var delete

  public init() {}
}

extension EditableItem.State {
  var canEdit: Bool { !(item.project?.closed ?? false) }
}
