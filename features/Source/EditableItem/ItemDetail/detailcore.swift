// Created by Leopold Lemmermann on 23.02.25.

import ComposableArchitecture
import Data

@Reducer public struct ItemDetail {
  @ObservableState public struct State: Equatable {
    public var item: Item
    @SharedReader public var projectWithItems: Project.WithItems

    public init(_ item: Item) {
      self.item = item
      _projectWithItems = SharedReader(
        wrappedValue: Project.WithItems(), .fetch(ProjectWithItemsRequest(itemId: item.id))
      )
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
