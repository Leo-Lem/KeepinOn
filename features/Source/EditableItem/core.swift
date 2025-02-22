// Created by Leopold Lemmermann on 20.02.25.

import ComposableArchitecture
import Data

@Reducer public struct EditableItem {
  @ObservableState public struct State: Equatable, Sendable {
    public var item: Item

    public init(_ item: Item) { self.item = item }
  }

  public enum Action {
    case delete
    case toggle
    case detail
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .delete:
        _ = try? database.write { try state.item.delete($0) }
        return .none

      case .toggle:
        state.item.done.toggle()
        try? database.write { try state.item.save($0) }
        return .none

      case .detail: return .none
      }
    }
  }

  @Dependency(\.defaultDatabase) var database

  public init() {}
}

extension EditableItem.State {
  var accent: Accent? {
    @Dependency(\.defaultDatabase) var database
    return try? database.read {
      try Project
        .filter(key: item.projectId)
        .select([Column("accent")], as: String.self)
        .fetchOne($0)
        .map(Accent.init)?.optional
    }
  }

  var canEdit: Bool {
    @Dependency(\.defaultDatabase) var database
    return !((try? database.read {
      try Project.filter(key: item.projectId).select([Column("closed")]).fetchOne($0)
    }) ?? false)
  }
}

extension EditableItem.State: Identifiable {
  public var id: Int64 { item.id ?? 0 }
}
