// Created by Leopold Lemmermann on 18.12.22.

import ComposableArchitecture
import LeosMisc
import SwiftUI

extension Project {
  struct ListView: View {
    let closed: Bool
    
    var body: some View {
      WithConvertiblesViewStore(
        matching: .init(\.isClosed, closed),
        from: \.privateDatabase.projects, loadWith: .init { .privateDatabase(.projects($0)) }
      ) { projects in
        WithConvertiblesViewStore(
          matching: .init(projects.map(\.id).map { .init(\.project, $0) }, compound: .or),
          from: \.privateDatabase.items, loadWith: .init { .privateDatabase(.items($0)) }
        ) { items in
          WithViewStore(store) { $0.sorting.itemSortOrder } send: { (action: ViewAction) in
            switch action {
            case let .setSortOrder(sortOrder): return .sorting(.setItemSortOrder(sortOrder))
            }
          } content: { sortOrder in
            WithPresentationViewStore { _, detail in
              Render(
                projects.sorted(by: \.timestamp, using: >), items: items, closed: closed,
                sortOrder: .init { sortOrder.state } set: { sortOrder.send(.setSortOrder($0)) },
                detail: detail
              )
            }
          }
        }
      }
    }
    
    @EnvironmentObject private var store: StoreOf<MainReducer>
    init(closed: Bool) { self.closed = closed }
    enum ViewAction { case setSortOrder(Item.SortOrder) }
    
    struct Render: View {
      let projects: [Project]
      let items: [Item]
      let closed: Bool
      @Binding var sortOrder: Item.SortOrder
      @Binding var detail: MainDetail
      
      var body: some View {
        List {
          ForEach(projects) { project in
            Section {
              ForEach(items(of: project.id).sorted(using: sortOrder)) { item in
                item.rowView()
                  .if(canEdit) { $0.itemContextMenu(item) }
                  .onTapGesture { detail = .item(id: item.id) }
              }
              
              if canEdit { Item.AddMenu(projectID: project.id) }
            } header: {
              Project.HeaderView(id: project.id, canEdit: canEdit)
            }
          }
        }
        .replace(if: projects.isEmpty, placeholder: "NO_PROJECTS_PLACEHOLDER")
        .accessibilityIdentifier("projects-list")
        .toolbar {
          if size == .regular { ToolbarItem { Item.SortOrder.SelectionMenu($sortOrder) } }
          if !closed { ToolbarItem(placement: .primaryAction) { Project.AddMenu() } }
        }
      }
      
      @Environment(\.size) private var size
      
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
