// Created by Leopold Lemmermann on 23.02.25.

import ComposableArchitecture
import Data

@Reducer public struct ItemDetail {
  @ObservableState public struct State: Equatable {
    @SharedReader public var item: Item
    @SharedReader public var projectWithItems: Project.WithItems

    public init(_ id: Item.ID) {
      _item = SharedReader(wrappedValue: Item(), .fetch(ItemRequest(id: id)))
      _projectWithItems = SharedReader(wrappedValue: Project.WithItems(), .fetch(ProjectWithItemsRequest(itemId: id)))
    }

    struct ItemRequest: FetchKeyRequest {
      let id: Item.ID

      func fetch(_ db: Database) throws -> Item {
        try Item.fetchOne(db, id: id) ?? Item()
      }
    }

    struct ProjectWithItemsRequest: FetchKeyRequest {
      let itemId: Item.ID

      func fetch(_ db: Database) throws -> Project.WithItems {
        try Project
          .including(all: Project.items)
          .filter(TableAlias(name: "item")[Column("id")] == itemId) // TODO: fix
          .asRequest(of: Project.WithItems.self)
          .fetchOne(db)
        ?? Project.WithItems()
      }
    }
  }

  public init() {}
}
