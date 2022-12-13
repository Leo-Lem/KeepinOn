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
        if let id = mainState.authenticationState.user?.id {
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
    .refreshable {
      tasks["loadProjects"] = Task(priority: .userInitiated) { await loadProjects() }
    }
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

#if os(iOS)
      if hSize == .compact {
        ToolbarItem(placement: .cancellationAction) { AccountMenu().labelStyle(.iconOnly) }
      }
#endif

#if DEBUG
      ToolbarItemGroup(content: testDataButtons)
#endif
    }
    .animation(.default, value: projects)
    .accessibilityElement(children: .contain)
    .accessibilityLabel("COMMUNITY_TITLE")
    .onAppear {
      tasks["loadProjects"] = Task(priority: .userInitiated) { await loadProjects() }
      tasks["updateProjects"] = Task(priority: .background) { await updateProjects() }
    }
  }

  @State private var selectedDetail: Detail?
  @Persisted("CommunityView-projects") private var projects: LoadingState<SharedProject> = .idle
  @State private var tasks = Tasks()
  @EnvironmentObject var mainState: MainState

#if os(iOS)
  @Environment(\.horizontalSizeClass) private var hSize
#endif

  init() {}
}

private extension CommunityView {
  @MainActor func loadProjects() async {
    do {
      try await mainState.displayError {
        let query = Query<SharedProject>(true, options: .init(batchSize: 5))
        for try await projects in try await mainState.publicDBService.fetch(query) { self.projects.add(projects) }
        projects.finish {}
      }
    } catch { projects.finish { throw error } }
  }

  @MainActor func updateProjects() async {
    await printError { @MainActor in
      for await event in mainState.publicDBService.events {
        switch event {
        case let .inserted(type, id) where type == SharedProject.self:
          if
            let id = id as? SharedProject.ID,
            let project: SharedProject = try await mainState.fetch(with: id, fromPrivate: false)
          {
            mainState.insert(project, into: &projects.wrapped)
            projects.finish {}
          }
        case let .deleted(type, id) where type == SharedProject.self:
          if let id = id as? SharedProject.ID { mainState.remove(with: id, from: &projects.wrapped) }
        case let .status(status) where status == .unavailable:
          break
        case .status, .remote:
          tasks["loadProjects"] = Task(priority: .high) { await loadProjects() }
        default:
          break
        }
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct CommunityView_Previews: PreviewProvider {
  static var previews: some View {
    CommunityView()
      .configureForPreviews()
  }
}
#endif
