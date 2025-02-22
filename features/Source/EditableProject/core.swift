// Created by Leopold Lemmermann on 20.02.25.

import ComposableArchitecture
import Data
import EditableItem

@Reducer public struct EditableProject {
  @ObservableState public struct State: Equatable {
    public var project: Project

    @SharedReader public var items: [Item]
    public var editableItems: IdentifiedArrayOf<EditableItem.State>
    @Presents public var alert: AlertState<Action.Alert>?
    public var detailing: Bool = false
    public var editing: Bool = false

    public init(
      _ project: Project,
      items: [Item] = [],
      detailing: Bool = false,
      editing: Bool = false
    ) {
      self.project = project
      _items = SharedReader(wrappedValue: items, .fetchAll(sql: """
        SELECT * 
        FROM item
        WHERE projectId=? 
        ORDER BY done
        """, arguments: [project.id]))
      editableItems = []
      self.detailing = detailing
      self.editing = editing
    }
  }

  public enum Action: BindableAction {
    case toggle
    case delete
    case addItem

    case loadItems
    case items([Item])
    case editableItems(IdentifiedActionOf<EditableItem>)

    case alert(PresentationAction<Alert>)
    public enum Alert: Equatable {
      case delete
    }

    case binding(BindingAction<State>)
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .delete:
        state.alert = AlertState {
          TextState(.localizable(.deleteAlertTitle))
        } actions: {
          ButtonState(role: .destructive, action: .send(.delete)) {
            TextState(.localizable(.delete))
          }
        }
        return .none

      case .toggle:
        return .send(.binding(.set(\.project.closed, !state.project.closed)))

      case .addItem:
        if let projectId = state.project.id {
          var item = Item(projectId: projectId)
          try? database.write { try item.save($0) }
        }
        return .none

      case .alert(.presented(.delete)):
        _ = try? database.write { try state.project.delete($0) }
        return .none

      case let .items(items):
        for id in state.editableItems.ids {
          if let item = items.first(where: { $0.id == id }) {
            state.editableItems[id: id]?.item = item
          } else {
            state.editableItems.remove(id: id)
          }
        }

        state.editableItems.append(
          contentsOf: IdentifiedArray(uniqueElements: items.map { EditableItem.State($0) })
        )

        return .none

      case .binding(\.project), .binding(\.project.closed):
        try? database.write { try state.project.save($0) }
        return .none

      case .loadItems:
        return .merge(
          .publisher { state.$items.publisher.map { .items($0) } },
          .send(.items(state.items))
        )

      case .alert, .editableItems, .binding: return .none
      }
    }
    .forEach(\.editableItems, action: \.editableItems, element: EditableItem.init)
    .ifLet(\.alert, action: \.alert)
  }

  @Dependency(\.defaultDatabase) var database

  public init() {}
}

public extension EditableProject.State {
  var withItems: Project.WithItems {
    @Dependency(\.defaultDatabase) var database
    return Project.WithItems(project, items: (try? database.read {
      try project.items.fetchAll($0)
    }) ?? [])
  }

  var progress: Double {
    @Dependency(\.defaultDatabase) var database
    return (try? database.read { db in
      project.progress(db)
    }) ?? 0
  }

  var canEdit: Bool { !project.closed }
}

extension EditableProject.State: Identifiable {
  public var id: Int64? { project.id }
}
