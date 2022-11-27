//	Created by Leopold Lemmermann on 07.10.22.

import AuthenticationService
import Concurrency
import Errors
import LeosMisc
import LocalAuthentication
import RemoteDatabaseService
import SwiftUI

struct CommunityView: View {
  var body: some View {
    List {
      switch projects {
      case let .loading(projects), let .loaded(projects):
        projects.listView(mainState.user?.id)

      #if DEBUG
        case let .failed(error): Text(error?.localizedDescription ?? "")
      #endif

      default:
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .refreshable { loadProjects() }
    .background(Config.style.background)
    .toolbar {
      accountMenu()

      if case .loading = projects { ToolbarItem(placement: .navigationBarTrailing) { ProgressView() } }

      #if DEBUG
        testDataToolbar()
      #endif
    }
    .sheet(isPresented: $isEditing) { mainState.user?.editingView() }
    .sheet(isPresented: $isAuthenticating) { AuthenticationView(service: mainState.authService) }
    .animation(.default, value: projects)
    .accessibilityLabel("COMMUNITY_TITLE")
    .task {
      loadProjects()
      tasks.add(mainState.remoteDBService.didChange.getTask(operation: updateProjects))
    }
  }

  @EnvironmentObject private var mainState: MainState
  @SceneStorage("editingIsUnlocked") private var editingIsUnlocked: Bool = false

  @State private var isAuthenticating = false
  @State private var isEditing = false
  @State private var projects: LoadingState<SharedProject> = .idle

  private let tasks = Tasks()
}

private extension CommunityView {
  func accountMenu() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Button {
        if mainState.user == nil { isAuthenticating = true } else { unlockEditing() }
      } label: {
        Label("ACCOUNT_TITLE", systemImage: "person.crop.circle")
          .labelStyle(.iconOnly)
      }
      .if(mainState.user != nil) { $0
        .disabled(mainState.remoteDBService.status == .unavailable)
        .contextMenu {
          Button(action: unlockEditing) {
            Label("ACCOUNT_EDIT", systemImage: "person.text.rectangle")
          }

          Button(action: logout) {
            Label("ACCOUNT_LOGOUT", systemImage: "person.fill.xmark")
              .labelStyle(.titleAndIcon)
          }
          .disabled(mainState.remoteDBService.status == .unavailable)
        }
      }
    }
  }

  #if DEBUG
    func testDataToolbar() -> some ToolbarContent {
      ToolbarItem(placement: .automatic) {
        HStack {
          Button("Add data") {
            Task(priority: .userInitiated) {
              await mainState.remoteDBService.createSampleData()
            }
          }
          Button("Delete All") {
            Task(priority: .userInitiated) {
              await mainState.remoteDBService.unpublishAll()
            }
          }
        }
      }
    }
  #endif
}

private extension CommunityView {
  func unlockEditing() {
    guard !editingIsUnlocked else { return isEditing = true }

    Task(priority: .userInitiated) {
      await printError {
        editingIsUnlocked = try await LAContext().evaluatePolicy(
          .deviceOwnerAuthentication,
          localizedReason: String(localized: "AUTHENTICATE_TO_EDIT_ACCOUNT")
        )
      }

      if editingIsUnlocked { isEditing = true }
    }
  }

  func logout() { printError(mainState.authService.logout) }

  func loadProjects() {
    tasks["loadingProjects"] = Task(priority: .userInitiated) {
      do {
        try await mainState.displayError {
          let query = Query<SharedProject>(true, options: .init(batchSize: 5))

          for try await projects in mainState.remoteDBService.fetch(query) { self.projects.add(projects) }

          projects.finish {}
        }
      } catch { projects.finish { throw error } }
    }
  }

  func updateProjects(on change: RemoteDatabaseChange) async {
    switch change {
    case let .published(convertible):
      if
        let project = convertible as? SharedProject,
        let index = projects.wrapped?.firstIndex(where: { $0.id == project.id })
      {
        projects.wrapped?[index] = project
      }
      projects.finish {}

    case let .unpublished(id, _):
      if
        let id = id as? SharedProject.ID,
        let index = projects.wrapped?.firstIndex(where: { $0.id == id })
      {
        projects.wrapped?.remove(at: index)
      }

    case let .status(status) where status != .unavailable: loadProjects()
    case .remote: loadProjects()
    default: break
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        CommunityView()
          .previewDisplayName("Bare")

        NavigationStack(root: CommunityView.init)
          .previewDisplayName("Navigation")
      }
      .configureForPreviews()
    }
  }
#endif
