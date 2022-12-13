//	Created by Leopold Lemmermann on 25.10.22.

import Concurrency
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
      startLoading(for: project)
      
      tasks["updateItems"] = communityController.databaseService.handleEventsTask(.userInitiated) { event in
        if await communityController.updateElements(on: event, by: { $0.project == project.id}, into: itemsBinding) {
          startLoading(for: project)
        }
      }
    }
    .onChange(of: project, perform: startLoading)
  }

  @Persisted private var items: LoadingState<SharedItem>
  private var itemsBinding: Binding<LoadingState<SharedItem>> {
    Binding(get: { items }, set: { items = $0 })
  }
  
  @EnvironmentObject var communityController: CommunityController
  
  private let tasks = Tasks()
  
  init(_ project: SharedProject) {
    self.project = project
    _items = Persisted(wrappedValue: .idle, "\(project.id)-items")
  }
  
  private func startLoading(for project: SharedProject) {
    tasks["loadItems"] = Task(priority: .userInitiated) {
      await communityController
        .loadElements(query: .init(\.project, .equal, project.id, options: .init(batchSize: 5)), into: itemsBinding)
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
      
    }
  }
#endif
