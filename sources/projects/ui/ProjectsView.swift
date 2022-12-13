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
    .accessibilityIdentifier("projects-list")
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
      ToolbarItem {
        Item.SortOrder.SelectionMenu($projectsController.sortOrder)
      }

      if !closed {
        ToolbarItem(placement: .primaryAction) {
          Project.AddButton {
            Label("ADD_PROJECT", systemImage: "rectangle.stack.badge.plus.fill")
              .accessibilityIdentifier("add-project")
          }
        }
      }
    }
    .accessibilityElement(children: .contain)
    .accessibilityLabel(closed ? "CLOSED_TITLE" : "OPEN_TITLE")
    .animation(.default, value: projects)
    .task {
      await loadProjects()
      tasks["updateProjects"] = projectsController.databaseService.handleEventsTask(.background, with: updateProjects)
    }
  }

  @State var selectedDetail: Detail?
  @Persisted var projects: [Project]

  private let tasks = Tasks()

  @EnvironmentObject private var projectsController: ProjectsController

  init(closed: Bool) {
    self.closed = closed
    _projects = Persisted(wrappedValue: [], closed ? "closedProjects" : "openProjects")
  }
}

private extension ProjectsView {
  @MainActor func loadProjects() async {
    await printError {
      projects = try await projectsController.databaseService
        .fetchAndCollect(Query<Project>(\.isClosed, .equal, closed))
    }
  }

  @MainActor func updateProjects(on event: DatabaseEvent) async {
    await printError {
      switch event {
      case let .inserted(type, id) where type == Project.self:
        if
          let id = id as? Project.ID,
          let project: Project = try await projectsController.databaseService.fetch(with: id)
        {
          if project.isClosed == closed {
            projectsController.insert(project, into: &projects)
          } else {
            projectsController.remove(with: project.id, from: &projects)
          }
        }
      case let .deleted(type, id) where type == Project.self:
        if let id = id as? Project.ID { projectsController.remove(with: id, from: &projects) }
      case .remote:
        await loadProjects()
      default:
        break
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
    
  }
}
#endif
