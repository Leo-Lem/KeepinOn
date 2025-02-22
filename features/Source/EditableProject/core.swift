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

    public init(
      _ project: Project,
      items: [Item] = []
    ) {
      self.project = project
      _items = SharedReader(wrappedValue: items, .fetchAll(sql: """
        SELECT * FROM item WHERE projectId=? ORDER BY done
        """, arguments: [project.id]))
      editableItems = []
    }
  }

  public enum Action {
    case toggle
    case delete
    case addItem

    case appear
    case items([Item])
    case editableItems(IdentifiedActionOf<EditableItem>)

    case alert(PresentationAction<Alert>)
    public enum Alert: Equatable {
      case delete
    }
  }

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .delete:
        state.alert = AlertState {
          TextState("DELETE_PROJECT_ALERT_TITLE")
        } actions: {
          ButtonState(role: .destructive, action: .send(.delete)) {
            TextState("DELETE")
          }
        }
        return .none

      case .toggle:
        state.project.closed.toggle()
        try? database.write { try state.project.save($0) }
        return .none

      case .addItem:
        if let projectId = state.project.id {
          var item = Item(projectId: projectId, title: "", details: "")
          try? database.write { try item.save($0) }
        }
        return .none

      case .alert(.presented(.delete)):
        _ = try? database.write { try state.project.delete($0) }
        return .none

      case .appear:
        return .merge(
          .publisher { state.$items.publisher.map { .items($0) } },
          .send(.items(state.items))
        )

      case let .items(items):
        state.editableItems = IdentifiedArray(uniqueElements: items.map(EditableItem.State.init))
        return .none

      case .alert, .editableItems: return .none
      }
    }
    .forEach(\.editableItems, action: \.editableItems, element: EditableItem.init)
  }

  @Dependency(\.defaultDatabase) var database

  public init() {}
}

public extension EditableProject.State {
  var progress: Double {
    @Dependency(\.defaultDatabase) var database
    return (try? database.read { db in
      project.progress(db)
    }) ?? 0
  }

  var canEdit: Bool { !project.closed }
}

extension EditableProject.State: Identifiable {
  public var id: Int64 { project.id ?? 0 }
}
