//	Created by Leopold Lemmermann on 25.10.22.

import Concurrency
import CloudKitService
import Errors
import LeosMisc
import SwiftUI

extension SharedProject {
  func itemsSectionView() -> some View { SharedItemsSectionView(self) }
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
      default:
        ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .animation(.default, value: items)
    .onAppear {
      tasks["loadItems"] = Task(priority: .userInitiated) { await loadItems(for: project) }
      tasks["updateItems"] = Task(priority: .background) { await updateItems() }
    }
    .onChange(of: project) { newProject in
      tasks["loadItems"] = Task(priority: .userInitiated) { await loadItems(for: newProject) }
    }
  }

  @Persisted private var items: LoadingState<SharedItem>
  @State private var tasks = Tasks()
  @EnvironmentObject private var mainState: MainState
  
  init(_ project: SharedProject) {
    self.project = project
    _items = Persisted(wrappedValue: .idle, "\(project.id)-items")
  }
}

private extension SharedItemsSectionView {
  @MainActor func loadItems(for project: SharedProject) async {
    do {
      try await mainState.displayError {
        let query = Query<SharedItem>(\.project, .equal, self.project.id, options: .init(batchSize: 5))
        for try await items in await mainState.publicDBService.fetch(query) { self.items.add(items) }
        items.finish {}
      }
    } catch { items.finish { throw error } }
  }

  @MainActor func updateItems() async {
    await printError {
      for await event in mainState.publicDBService.events {
        switch event {
        case let .inserted(type, id) where type == SharedItem.self:
          if
            let id = id as? SharedItem.ID,
            project.items.contains(id),
            let item: SharedItem = try await mainState.fetch(with: id, fromPrivate: false)
          {
            mainState.insert(item, into: &items.wrapped)
            items.finish {}
          }
        case let .deleted(type, id) where type == SharedItem.self:
          if let id = id as? SharedItem.ID { mainState.remove(with: id, from: &items.wrapped) }
        case let .status(status) where status == .unavailable:
          break
        case .status, .remote:
          tasks["loadItems"] = Task(priority: .high) { await loadItems(for: project) }
        default:
          break
        }
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct SharedItemsListView_Previews: PreviewProvider {
    static var previews: some View {
      List {
        SharedItemsSectionView(.example)
      }
      .padding()
      .configureForPreviews()
    }
  }
#endif
