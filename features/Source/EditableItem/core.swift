// Created by Leopold Lemmermann on 20.02.25.

import ComposableArchitecture
import Data

@Reducer public struct EditableItem {
  @ObservableState public struct State: Equatable, Sendable {
    public var item: Item

    public var detail: Bool = false

    public init(_ item: Item) { self.item = item }
  }

  public enum Action: BindableAction {
    case delete
    case toggle
    case detail

    case binding(BindingAction<State>)
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .delete:
        _ = try? database.write { try state.item.delete($0) }
        return .none

      case .toggle:
        return .send(.binding(.set(\.item.done, !state.item.done)))

      case .detail:
        return .send(.binding(.set(\.detail, true)))

      case .binding(\.item):
        try? database.write { try state.item.save($0) }
        return .none

      case .binding: return .none
      }
    }
  }

  @Dependency(\.defaultDatabase) var database

  public init() {}
}

extension EditableItem.State {
  var project: Project.WithItems {
    @Dependency(\.defaultDatabase) var database
    return (try? database.read {
      try Project
        .including(all: Project.items)
        .asRequest(of: Project.WithItems.self)
        .filter(key: item.projectId)
        .fetchOne($0)
    }) ?? .init(Project(title: "", details: "", accent: .green, closed: false), items: [item])
  }

  var accent: Accent { project.project.accent }

  var canEdit: Bool { !project.project.closed }
}

extension EditableItem.State: Identifiable {
  public var id: Int64? { item.id }
}
