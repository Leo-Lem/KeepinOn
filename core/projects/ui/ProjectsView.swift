//  Created by Leopold Lemmermann on 09.10.2022.

import Concurrency
import CoreDataService
import Errors
import Foundation
import LeosMisc
import SwiftUI

struct ProjectsView: View {
  let closed: Bool

  var body: some View {
    List {
      ForEach(projects) { project in
        Section {
          project.itemsListView(canEdit: !closed, selectedDetail: $selectedDetail)
        } header: {
          project.headerView(canEdit: !closed, selectedDetail: $selectedDetail)
        }
      }
    }
    .listStyle(.inset)
    .presentDetail($selectedDetail) { detail in
      switch detail {
      case let .project(project): project.detailView()
      case let .editProject(project): project.editingView()
      case let .item(item): item.detailView()
      case let .editItem(item): item.editingView()
      default: Text("EMPTY_TAB_PLACEHOLDER")
      }
    }
    .navigationTitle(closed ? "CLOSED_TITLE" : "OPEN_TITLE")
    .toolbar {
      if !closed {
        ToolbarItem {
          Item.SortOrder.SelectionMenu($mainState.sortOrder)
        }

        ToolbarItem(placement: .primaryAction) {
          Project.AddButton { Label("ADD_PROJECT", systemImage: "rectangle.stack.badge.plus.fill") }
        }
      }
    }
    .accessibilityElement(children: .contain)
    .accessibilityLabel(closed ? "CLOSED_TITLE" : "OPEN_TITLE")
    .animation(.default, value: projects)
    .task {
      await loadProjects()
      tasks["updateProjects"] = Task(priority: .background) { await updateProjects() }
    }
  }

  @State var selectedDetail: Detail?
  @Persisted var projects: [Project]
  @State private var tasks = Tasks()
  @EnvironmentObject var mainState: MainState

  init(closed: Bool) {
    self.closed = closed
    _projects = Persisted(wrappedValue: [], "ProjectsView-\(closed ? "closed" : "open")Projects")
  }
}

private extension ProjectsView {
  @MainActor func loadProjects() async {
    await printError {
      projects = try await mainState.privateDBService.fetchAndCollect(Query<Project>(\.isClosed, .equal, closed))
    }
  }

  @MainActor func updateProjects() async {
    await printError {
      for await event in mainState.privateDBService.events {
        switch event {
        case let .inserted(type, id) where type == Project.self:
          if let id = id as? Project.ID, let project: Project = try await mainState.fetch(with: id) {
            if project.isClosed == closed {
              mainState.insert(project, into: &projects)
            } else {
              mainState.remove(with: project.id, from: &projects)
            }
          }
        case let .deleted(type, id) where type == Project.self:
          if let id = id as? Project.ID { mainState.remove(with: id, from: &projects) }
        case .remote:
          await loadProjects()
        default:
          break
        }
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ProjectsView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ProjectsView(closed: false)
        .previewDisplayName("Open")

      ProjectsView(closed: true)
        .previewDisplayName("Closed")
    }
    .configureForPreviews()
  }
}
#endif
