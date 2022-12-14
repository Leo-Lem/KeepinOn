//	Created by Leopold Lemmermann on 07.10.22.

import CloudKitService
import Concurrency
import Errors
import LeosMisc
import LocalAuthentication
import SwiftUI

struct CommunityView: View {
  var body: some View {
    List {
      if let unwrappedProjects = projects.wrapped {
        if let id = accountService.id {
          let projects: (own: [SharedProject], others: [SharedProject]) = unwrappedProjects
            .partitioning { $0.owner != id }

          Section("OWN_USERS_PROJECTS") {
            ForEach(projects.own) { project in
              Button(action: { selectedDetail = .sharedProject(project) }, label: project.rowView)
            }
            .replaceIfEmpty(with: "NO_PROJECTS_PLACEHOLDER")
          }

          Section("OTHER_USERS_PROJECTS") {
            ForEach(projects.others) { project in
              Button(action: { selectedDetail = .sharedProject(project) }, label: project.rowView)
            }
            .replaceIfEmpty(with: "NO_PROJECTS_PLACEHOLDER")
          }
        } else {
          ForEach(unwrappedProjects) { project in
            Button(action: { selectedDetail = .sharedProject(project) }, label: project.rowView)
          }
          .replaceIfEmpty(with: "NO_PROJECTS_PLACEHOLDER")
        }
      }
    }
    .refreshable { startLoading() }
    .listStyle(.inset)
    .presentDetail($selectedDetail) { detail in
      switch detail {
      case let .sharedProject(shared): shared.detailView()
      default: Text("EMPTY_TAB_PLACEHOLDER")
      }
    }
    .navigationTitle("COMMUNITY_TITLE")
    .toolbar {
      if case .loading = projects { ToolbarItem(content: ProgressView.init) }

#if DEBUG
      ToolbarItemGroup(content: testDataButtons)
#endif
    }
    .animation(.default, value: projects)
    .accessibilityElement(children: .contain)
    .accessibilityLabel("COMMUNITY_TITLE")
    .onAppear {
      startLoading()

      tasks["updateProjects"] = communityController.databaseService.handleEventsTask(.userInitiated) { event in
        if await communityController.updateElements(on: event, by: { _ in true }, into: projectsBinding) {
          startLoading()
        }
      }
    }
  }

  @State private var selectedDetail: Detail?

  @Persisted("CommunityView-projects") private var projects: LoadingState<SharedProject> = .idle
  private var projectsBinding: Binding<LoadingState<SharedProject>> {
    Binding(get: { projects }, set: { projects = $0 })
  }

  @EnvironmentObject var communityController: CommunityController
  @EnvironmentObject private var accountService: AccountController

  private let tasks = Tasks()

  init() {}

  private func startLoading() {
    tasks["loadProjects"] = Task(priority: .userInitiated) {
      await communityController.loadElements(query: .init(true, options: .init(batchSize: 5)), into: projectsBinding)
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct CommunityView_Previews: PreviewProvider {
  static var previews: some View {
    CommunityView()
  }
}
#endif
