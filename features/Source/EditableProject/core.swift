// Created by Leopold Lemmermann on 20.02.25.

import ComposableArchitecture
import Data
import EditableItem

@Reducer public struct EditableProject {
  @ObservableState public struct State: Equatable {
    public var project: Project

    @SharedReader public var itemIds: [Item.ID]
    public var items: IdentifiedArrayOf<EditableItem.State>

    @Presents public var alert: AlertState<Action.Alert>?

    public var detailing: Bool = false
    public var editing: Bool = false

    public init(
      _ project: Project,
      detailing: Bool = false,
      editing: Bool = false
    ) {
      self.project = project
      _itemIds = SharedReader(wrappedValue: [], .fetch(ItemIds(projectId: project.id)))
      items = []
      self.detailing = detailing
      self.editing = editing
    }

    struct ItemIds: FetchKeyRequest {
      let projectId: Project.ID

      func fetch(_ db: Database) throws -> [Item.ID] {
        try Item.all()
          .filter(Column("projectId") == projectId)
          .select(Column("id"))
          .fetchAll(db)
      }
    }
  }

  public enum Action: BindableAction {
    case toggle
    case delete
    case addItem

    case loadItems
    case itemIds([Item.ID])
    case items(IdentifiedActionOf<EditableItem>)

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

      case let .itemIds(ids):
        state.items.removeAll { ids.contains($0.id) }
        state.items.append(contentsOf: IdentifiedArray(uniqueElements: ids.map { EditableItem.State($0) }))
        return .none

      case .binding(\.project):
        try? database.write { try state.project.save($0) }
        return .none

      case .loadItems:
        return .merge(
          .publisher { state.$itemIds.publisher.map { .itemIds($0) } },
          .send(.itemIds(state.itemIds))
        )

      case .alert, .items, .binding: return .none
      }
    }
    .forEach(\.items, action: \.items, element: EditableItem.init)
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

extension EditableItem.State: Identifiable {
  public var id: Int64? { item.id }
}
