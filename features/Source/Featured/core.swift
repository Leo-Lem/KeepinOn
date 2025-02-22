// Created by Leopold Lemmermann on 22.02.25.

import ComposableArchitecture
import Data

@Reducer public struct Featured {
  @ObservableState public struct State: Equatable {
    @SharedReader public var _projects: [Project]
    @SharedReader public var _items: [Item]

    public var projects: [Project.WithItems] {
      @Dependency(\.defaultDatabase) var database
      return (try? database.read { db in
        try Project
          .including(all: Project.items)
          .asRequest(of: Project.WithItems.self)
          .filter(ids: _projects.map(\.id))
          .fetchAll(db)
      }) ?? []
    }
    public var items: [Item.WithProject] {
      @Dependency(\.defaultDatabase) var database
      return (try? database.read { db in
        try Item
          .including(required: Item.project)
          .asRequest(of: Item.WithProject.self)
          .filter(ids: _items.map(\.id))
          .fetchAll(db)
      }) ?? []
    }

    public init(
      projects: [Project] = [],
      items: [Item] = []
    ) {
      __projects = SharedReader(wrappedValue: projects, .fetchAll(sql: """
        SELECT * FROM project
        WHERE closed=?
        ORDER BY createdAt DESC
        LIMIT 3 
        """, arguments: [false]))
      __items = SharedReader(wrappedValue: items, .fetchAll(sql: """
        SELECT item.*
        FROM item
        JOIN project ON project.id=item.projectId
        WHERE item.done=0 AND project.closed=0
        ORDER BY item.createdAt DESC
        LIMIT 3
        """))
    }
  }

  public enum Action {
    case nothing
  }

  public var body: some Reducer<State, Action> {
    Reduce { _, action in
      switch action {
      case .nothing: return .none
      }
    }
  }

  public init() {}
}
