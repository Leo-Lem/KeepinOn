// Created by Leopold Lemmermann on 20.02.25.

import ComposableArchitecture
import Data

@Reducer public struct EditableItem {
  @ObservableState public struct State: Equatable {
    @SharedReader public var itemWithProject: Item.WithProject
    public var item: Item { itemWithProject.item }

    @Presents public var detail: ItemDetail.State?
    @Presents public var edit: ItemEdit.State?

    public init(
      _ id: Item.ID,
      detail: ItemDetail.State? = nil,
      edit: ItemEdit.State? = nil
    ) {
      _itemWithProject = SharedReader(wrappedValue: Item.WithProject(), .fetch(ItemWithProjectRequest(id: id)))
      self.detail = detail
      self.edit = edit
    }

    private struct ItemWithProjectRequest: FetchKeyRequest {
      let id: Item.ID

      func fetch(_ db: Database) throws -> Item.WithProject {
        try Item
          .filter(id: id)
          .including(required: Item.project)
          .asRequest(of: Item.WithProject.self)
          .fetchOne(db)
        ?? Item.WithProject()
      }
    }
  }

  public enum Action {
    case item(Item)
    case deleteTapped
    case editTapped
    case detailTapped

    case detail(PresentationAction<ItemDetail.Action>)
    case edit(PresentationAction<ItemEdit.Action>)
  }

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case var .item(item):
        try? database.write { try item.save($0) }
        return .none

      case .deleteTapped:
        _ = try? database.write { try state.item.delete($0) }
        return .none

      case .editTapped:
        state.edit = ItemEdit.State(state.item)
        return .none

      case .detailTapped:
        state.detail = ItemDetail.State(state.item.id)
        return .none

      case .detail, .edit: return .none
      }
    }
    .ifLet(\.$edit, action: \.edit) { ItemEdit() }
    .ifLet(\.$detail, action: \.detail) { ItemDetail() }
  }

  @Dependency(\.defaultDatabase) var database

  public init() {}
}

extension EditableItem.State {
  var accent: Accent { itemWithProject.project.accent }
  var canEdit: Bool { !itemWithProject.project.closed }
}
