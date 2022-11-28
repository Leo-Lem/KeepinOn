//	Created by Leopold Lemmermann on 25.10.22.

import Concurrency
import RemoteDatabaseService
import SwiftUI
import LeosMisc

extension SharedProject {
  func itemsSectionView(items: LoadingState<SharedItem> = .idle) -> some View {
    SharedItemsSectionView(self, items: items)
  }
}

struct SharedItemsSectionView: View {
  let project: SharedProject

  var body: some View {
    Section {
      switch items {
      case let .loading(items), let .loaded(items):
        ForEach(items.sorted { first, _ in !first.isDone }, content: SharedItem.RowView.init)
          .replaceIfEmpty(with: "NO_SHAREDITEMS_PLACEHOLDER")
        if self.items.isLoading { ProgressView().frame(maxWidth: .infinity) }

      #if DEBUG
        case let .failed(error): Text(error?.localizedDescription ?? "")
      #endif
      default: ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .animation(.default, value: items)
    .task {
      loadItems()
      tasks.add(mainState.remoteDBService.didChange.getTask(operation: updateItems))
    }
  }

  @EnvironmentObject private var mainState: MainState
  @State private var items: LoadingState<SharedItem>

  private let tasks = Tasks()

  init(
    _ project: SharedProject,
    items: LoadingState<SharedItem> = .idle
  ) {
    self.project = project
    _items = State(initialValue: items)
  }
}

private extension SharedItemsSectionView {
  func loadItems() {
    tasks["loadingItems"] = Task(priority: .userInitiated) {
      do {
        try await mainState.displayError {
          let query = Query<SharedItem>(\.project, .equal, self.project.id, options: .init(batchSize: 5))
          for try await items in mainState.remoteDBService.fetch(query) {
            self.items.add(items)
          }

          items.finish {}
        }
      } catch { items.finish { throw error } }
    }
  }

  func updateItems(on change: RemoteDatabaseChange) async {
    switch change {
    case let .published(convertible):
      if
        let item = convertible as? SharedItem,
        let index = items.wrapped?.firstIndex(where: { $0.id == project.id })
      {
        items.wrapped?[index] = item
      }
      items.finish {}

    case let .unpublished(id, _):
      if
        let id = id as? SharedItem.ID,
        let index = items.wrapped?.firstIndex(where: { $0.id == id })
      {
        items.wrapped?.remove(at: index)
      }

    case let .status(status) where status != .unavailable: loadItems()
    case .remote: loadItems()
    default: break
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct SharedItemsListView_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        SharedItemsSectionView(.example, items: .idle)
          .previewDisplayName("Idle")

        List {
          SharedItemsSectionView(.example, items: .loading([.example, .example]))
        }
        .listStyle(.plain)
        .previewDisplayName("Loading")

        List {
          SharedItemsSectionView(.example, items: .loaded([.example, .example, .example]))
        }
        .listStyle(.plain)
        .previewDisplayName("Loaded")

        SharedItemsSectionView(.example, items: .failed(nil))
          .previewDisplayName("Failed")
      }
      .padding()
      .configureForPreviews()
    }
  }
#endif
