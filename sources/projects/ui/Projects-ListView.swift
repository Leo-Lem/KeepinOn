// Created by Leopold Lemmermann on 18.12.22.

import ComposableArchitecture
import Errors
import Queries
import SwiftUI

extension Project {
  struct ListView: View {
    let closed: Bool
    
    var body: some View {
      WithViewStore<ViewState, ViewAction, _>(store) { state in
        let projects = state.privateDatabase.projects.convertibles(matching: query)
        let items = state.privateDatabase.items.convertibles(matching: itemsQuery(for: projects.map(\.id)))
        return ViewState(projects: projects, items: items, itemSortOrder: state.sorting.itemSortOrder)
      } send: { action in
        switch action {
        case .load:
          return .privateDatabase(.projects(.loadFor(query: query)))
        case let .loadItems(projectIDs):
          return .privateDatabase(.items(.loadFor(query: itemsQuery(for: projectIDs))))
        case let .setSortOrder(sortOrder):
          return .sorting(.setItemSortOrder(sortOrder))
        }
      } content: { vm in
        Render(
          vm.projects.sorted(by: \.timestamp, using: >), items: vm.items, closed: closed,
          sortOrder: vm.binding(get: \.itemSortOrder, send: (/ViewAction.setSortOrder).embed)
        )
        .animation(.default, value: vm.projects.sorted(by: \.timestamp, using: >))
        .animation(.default, value: vm.items)
        .task {
          await vm.send(.load, animation: .default).finish()
          await vm.send(.loadItems(projectIDs: vm.projects.map(\.id)), animation: .default).finish()
        }
      }
    }
    
    @EnvironmentObject private var store: StoreOf<MainReducer>
    private var query: Query<Project> { Query<Project>(\.isClosed, closed) }
    private func itemsQuery(for projectIDs: [Project.ID]) -> Query<Item> {
      Query(projectIDs.map { .init(\.project, $0) }, compound: .or)
    }
    
    init(closed: Bool) { self.closed = closed }
    
    struct ViewState: Equatable {
      var projects: [Project]
      var items: [Item]
      var itemSortOrder: Item.SortOrder
    }
      
    enum ViewAction {
      case load
      case loadItems(projectIDs: [Project.ID])
      case setSortOrder(Item.SortOrder)
    }
    
    struct Render: View {
      let projects: [Project]
      let items: [Item]
      let closed: Bool
      @Binding var sortOrder: Item.SortOrder
      
      var body: some View {
        List {
          ForEach(projects) { project in
            Section {
              ForEach(items(of: project.id).sorted(using: sortOrder)) { item in
                item.rowView()
                  .if(canEdit) { $0.itemContextMenu(item) }
                  .onTapGesture { present(MainDetail.item(item)) }
              }
              
              if canEdit { Item.ActionMenu.add(projectID: project.id) }
            } header: {
              project.headerView(canEdit: canEdit)
            }
          }
        }
        .replace(if: projects.isEmpty, placeholder: "NO_PROJECTS_PLACEHOLDER")
        .accessibilityIdentifier("projects-list")
        .toolbar {
          if size == .regular { ToolbarItem { Item.SortOrder.SelectionMenu($sortOrder) } }
          if !closed { ToolbarItem(placement: .primaryAction) { Project.ActionMenu.add } }
        }
      }
      
      @Environment(\.size) private var size
      @Environment(\.present) private var present
      
      private var canEdit: Bool { !closed }
      private func items(of projectID: Project.ID) -> [Item] { items.filter { $0.project == projectID } }
      
      init(_ projects: [Project], items: [Item], closed: Bool, sortOrder: Binding<Item.SortOrder>) {
        (self.projects, self.items, self.closed) = (projects, items, closed)
        _sortOrder = sortOrder
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ProjectsView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Project.ListView.Render([], items: [], closed: false, sortOrder: .constant(.optimized))
        .previewDisplayName("Empty")

      let projects = [Project.example, .example, .example]
      let items = Array(projects.map { project in project.items.map { Item(id: $0, project: project.id) } }.joined())
      
      NavigationStack {
        Project.ListView.Render(
          projects.filter { !$0.isClosed }, items: items, closed: false, sortOrder: .constant(.optimized)
        )
      }
      .previewDisplayName("Open")

      NavigationStack {
        Project.ListView.Render(
          projects.filter(\.isClosed), items: items, closed: true, sortOrder: .constant(.optimized)
        )
      }
      .previewDisplayName("Closed")
    }
    .environmentObject(StoreOf<MainReducer>(initialState: .init(), reducer: MainReducer()))
    .presentPreview()
  }
}
#endif
