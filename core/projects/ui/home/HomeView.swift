//	Created by Leopold Lemmermann on 07.10.22.

import Concurrency
import Errors
import LocalDatabaseService
import SwiftUI

struct HomeView: View {
  var body: some View {
    ScrollView {
      projects.cardListView()

      VStack(alignment: .leading) {
        let items = (upNext: Array(items.prefix(3)), beyond: Array(items.dropFirst(3)))

        items.upNext.cardListView("NEXT_ITEMS")
        items.beyond.cardListView("MORE_ITEMS")
      }
      .padding(.horizontal)
    }
    .task {
      loadProjectsAndItems()
      tasks["ProjectAndItemsState"] = mainState.localDBService.didChange.getTask(operation: updateProjectsAndItems)
    }
    #if DEBUG
      .toolbar {
        ToolbarItem(placement: .automatic) {
          HStack {
            let service = mainState.localDBService
            Button("Add data") { service.createSampleData() }
            Button("Delete All") { service.deleteAll() }
          }
        }
      }
    #endif
  }

  @EnvironmentObject private var mainState: MainState
  @State private var projects = [Project]()
  @State private var items = [Item]()

  private let tasks = Tasks()
}

private extension HomeView {
  func loadProjectsAndItems() {
    printError {
      projects = try mainState.localDBService.fetch(Query<Project>(\.isClosed, .equal, false))
      items = try mainState.localDBService
        .fetch(Query<Item>(\.isDone, .equal, false))
        .filter { item in
          printError {
            if let project: Project = try mainState.localDBService.fetch(with: item.project) {
              return !project.isClosed
            } else { return nil }
          } ?? false
        }
    }
  }

  func updateProjectsAndItems(on change: LocalDatabaseChange) {
    loadProjectsAndItems()
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        HomeView()
          .previewDisplayName("Bare")

        NavigationStack(root: HomeView.init)
          .previewDisplayName("Navigation")
      }
      .configureForPreviews()
    }
  }
#endif
