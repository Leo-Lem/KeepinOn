// Created by Leopold Lemmermann on 20.02.25.

import ComposableArchitecture
import Data
import EditableItem

@Reducer public struct EditableProject {
  @ObservableState public struct State: Equatable {
    public var project: Project

    @SharedReader var items: [Item]

    var editableItems: IdentifiedArrayOf<EditableItem.State> {
      get { IdentifiedArray(uniqueElements: items.map(EditableItem.State.init)) }
      set { _ = newValue }
    }

    @Presents public var alert: AlertState<Action.Alert>?

    public init(
      _ project: Project,
      items: [Item] = []
    ) {
      self.project = project
      _items = SharedReader(wrappedValue: items,
                            .fetchAll(sql: "SELECT * FROM item WHERE item.projectId=?", arguments: [project.id]))
    }
  }

  public enum Action {
    case toggle
    case delete
    case edit
    case addItem

    case items(IdentifiedActionOf<EditableItem>)

    case alert(PresentationAction<Alert>)
    public enum Alert: Equatable {
      case delete
    }
  }

  public var body: some Reducer<State, Action> {
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
//        return .send(.alert(.presented(.delete)))

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

      case .edit, .alert, .items: return .none
      }
    }
    .forEach(\.editableItems, action: \.items, element: EditableItem.init)
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
