//	Created by Leopold Lemmermann on 07.10.22.

import Concurrency
import CoreDataService
import Errors
import LeosMisc
import SwiftUI

struct HomeView: View {
  var body: some View {
    ScrollView {
      ScrollView(.horizontal, showsIndicators: false) {
        projects.cardListView()
      }
      .accessibilityIdentifier("featured-projects-list")

      Group {
#if os(iOS)
        if hSize == .regular {
          HStack(alignment: .top) {
            VStack { Array(items.prefix(3)).cardListView("NEXT_ITEMS") }
            VStack { Array(items.dropFirst(3)).cardListView("MORE_ITEMS") }
          }
        } else {
          VStack {
            Array(items.prefix(3)).cardListView("NEXT_ITEMS")
            Array(items.dropFirst(3)).cardListView("MORE_ITEMS")
          }
        }
#elseif os(macOS)
        HStack(alignment: .top) {
          VStack { Array(items.prefix(3)).cardListView("NEXT_ITEMS") }
          VStack { Array(items.dropFirst(3)).cardListView("MORE_ITEMS") }
        }
#endif
      }
      .padding()
    }
    .replace(if: projects.isEmpty && items.isEmpty) {
      Project.AddButton(label: Label("CLICK_TO_ADD_FIRST_PROJECT", systemImage: "rectangle.badge.plus").create)
        .buttonStyle(.borderedProminent)
        .accessibilityIdentifier("add-first-project")
    }
    .navigationTitle("HOME_TITLE")
    .toolbar {
#if os(iOS)
      if hSize == .compact {
        ToolbarItem(placement: .cancellationAction) {
          AccountMenu().labelStyle(.iconOnly)
        }
      }
#endif
    }
    .toolbar {
#if DEBUG
      ToolbarItemGroup(content: testDataButtons)
#endif
    }
    .accessibilityElement(children: .contain)
    .accessibilityLabel("HOME_TITLE")
    .animation(.default, value: projects)
    .animation(.default, value: items)
    .task {
      await loadProjectsAndItems()
      tasks["updateProjectsAndItems"] = Task(priority: .background) { await updateProjectsAndItems() }
    }
  }

  @Persisted("HomeView-projects") var projects: [Project] = []
  @Persisted("HomeView-items") var items: [Item] = []
  @State private var tasks = Tasks()

  @EnvironmentObject var mainState: MainState

#if os(iOS)
  @Environment(\.horizontalSizeClass) var hSize
#endif

  init() {}
}

private extension HomeView {
  @MainActor func loadProjectsAndItems() async {
    await printError {
      projects = try await mainState.privateDBService.fetchAndCollect(Query<Project>(\.isClosed, .equal, false))
      items = try await mainState.privateDBService.fetchAndCollect(Query<Item>(\.isDone, .equal, false))
        .filter { item in
          guard let project: Project = try await mainState.fetch(with: item.project) else { return false }
          return !project.isClosed
        }
    }
  }

  // swiftlint:disable cyclomatic_complexity
  @MainActor func updateProjectsAndItems() async {
    await printError {
      for await event in mainState.privateDBService.events {
        switch event {
        case let .inserted(type, id) where type == Project.self:
          if
            let id = id as? Project.ID,
            let project: Project = try await mainState.fetch(with: id),
            !project.isClosed
          {
            mainState.insert(project, into: &projects)
          }
        case let .inserted(type, id) where type == Item.self:
          if
            let id = id as? Item.ID,
            let item: Item = try await mainState.fetch(with: id), !item.isDone,
            await !((try await mainState.fetch(with: item.project) as Project?)?.isClosed ?? true)
          {
            mainState.insert(item, into: &items)
          }
        case let .deleted(type, id) where type == Project.self:
          if let id = id as? Project.ID { mainState.remove(with: id, from: &projects) }
        case let .deleted(type, id) where type == Item.self:
          if let id = id as? Item.ID { mainState.remove(with: id, from: &projects) }
        case .remote:
          await loadProjectsAndItems()
        default: break
        }
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
      .configureForPreviews()
  }
}
#endif
