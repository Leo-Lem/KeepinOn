//  Created by Leopold Lemmermann on 07.10.22.

import ComposableArchitecture
import Errors
import LeosMisc
import Queries
import SwiftUI

extension Item {
  struct FeaturedView: View {
    struct ViewState: Equatable { var items: [Item] }
    enum ViewAction {
      case loadItems
      case loadProjects(items: [Item])
    }

    var body: some View {
      WithViewStore<ViewState, ViewAction, _>(store) { state in
        let items = state.privateDatabase.items.convertibles(matching: query)
          .filter { item in !(state.privateDatabase.projects.convertible(with: item.project)?.isClosed ?? true) }
        return ViewState(items: items)
      } send: { action in
          .privateDatabase({
            switch action {
            case .loadItems:
              return .items(.loadFor(query: query))
            case let .loadProjects(items):
              return .projects(.loadFor(query: projectsQuery(for: items.map(\.project))))
            }
          }())
      } content: { vm in
        Render(vm.items.sorted(using: .optimized))
          .task {
            await vm.send(.loadItems, animation: .default).finish()
            await vm.send(.loadProjects(items: vm.items), animation: .default).finish()
          }
      }
    }

    @EnvironmentObject private var store: StoreOf<MainReducer>
    private let query = Query<Item>(\.isDone, false)
    private func projectsQuery(for projectIDs: [Item.ID]) -> Query<Project> {
      Query(projectIDs.map { .init(\.id, $0) }, compound: .or)
    }

    struct Render: View {
      let items: (next: ArraySlice<Item>, more: ArraySlice<Item>)

      var body: some View {
        ScrollView {
          VStack {
            if !items.next.isEmpty { title("NEXT_ITEMS") }

            Group { if size == .compact { list(items.next) } else { HStack { list(items.next) }.padding() } }

            if !items.more.isEmpty { title("MORE_ITEMS") }

            list(items.more)
          }
          .padding()
        }
        .border(.top)
        .replace(if: items.next.isEmpty, placeholder: "ITEMS_ALL_DONE")
      }

      @State private var presentedItem: Item?
      @Environment(\.size) var size

      init(_ items: [Item]) {
        self.items = (items.prefix(3), items.dropFirst(3))
      }

      private func title(_ key: LocalizedStringKey) -> some View {
        Text(key)
          .foregroundColor(.secondary)
          .padding(.top)
      }

      private func list<C: RandomAccessCollection<Item>>(_ items: C) -> some View {
        ForEach(items) { item in
          item.peekView()
            .onTapGesture { presentedItem = item }
            .presentModal($presentedItem, presented: item) { $0.detailView() }
        }
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ItemFeaturedView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Item.FeaturedView.Render([]).previewDisplayName("Empty")
      Item.FeaturedView.Render([.example, .example, .example, .example, .example])
    }
    .presentPreview()
  }
}
#endif
