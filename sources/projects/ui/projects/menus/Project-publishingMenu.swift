//	Created by Leopold Lemmermann on 25.10.22.

import AuthenticationUI
import Concurrency
import CoreHapticsService
import DatabaseService
import Errors
import LeosMisc
import SwiftUI

extension Project {
  func publishingMenu() -> some View { PublishingMenu(self) }

  struct PublishingMenu: View {
    let project: Project

    var body: some View {
      EmptyView().waitFor(isPublished) { isPublished in
        AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) { await publish() } label: {
          isPublished ?
            Label("REPUBLISH_PROJECT", systemImage: "arrow.clockwise.icloud") :
            Label("PUBLISH_PROJECT", systemImage: "icloud.and.arrow.up")
        }

        if isPublished {
          AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) { await unpublish() } label: {
            Label("UNPUBLISH_PROJECT", systemImage: "xmark.icloud")
          }
        }
      }
      .animation(.default, value: isPublished)
      .accessibilityElement(children: .contain)
      .popover(isPresented: $isAuthenticating) { AuthenticationView(service: accountController.authService) }
      .alert("CANT_CONNECT_TO_ICLOUD_TITLE", isPresented: $isShowingiCloudError) {} message: {
        Text("CANT_CONNECT_TO_ICLOUD_MESSAGE")
      }
      .alert(isPresented: Binding(item: $error), error: error) {}
      .task {
        await loadIsPublished()
        tasks["updateIsPublished"] = communityController.databaseService
          .handleEventsTask(.background, with: updateIsPublished)
      }
    }

    @Persisted private var isPublished: Bool?
    @State private var isAuthenticating = false
    @State private var isShowingiCloudError = false
    @State private var error: DatabaseError?

    private let tasks = Tasks()

    @State private var hapticsService = CoreHapticsService()

    @EnvironmentObject private var projectsController: ProjectsController
    @EnvironmentObject private var communityController: CommunityController
    @EnvironmentObject private var accountController: AccountController

    init(_ project: Project) {
      self.project = project
      _isPublished = Persisted(wrappedValue: nil, "\(project.id)-isPublished")
    }
  }
}

private extension Project.PublishingMenu {
  func publish() async {
    await printError {
      guard let user = getUser() else { return }

      do {
        try await communityController.databaseService.insert(
          try await project.items.compactMap { id in
            try await communityController.databaseService.fetch(with: id).flatMap(SharedItem.init)
          }
        ).collect()

        try await communityController.databaseService.insert(SharedProject(project, owner: user.id))

        hapticsService?.play(.taDa)
      } catch let error as DatabaseError where error.hasDescription { self.error = error }
    }
  }

  @MainActor func unpublish() async {
    await printError {
      guard getUser() != nil else { return }

      do {
        try await communityController.databaseService.delete(SharedProject.self, with: project.id)
        isPublished = nil
      } catch let error as DatabaseError where error.hasDescription { self.error = error }
    }
  }

  private func getUser() -> User? {
    if let user = accountController.user {
      return user
    } else if accountController.isAuthenticated {
      isShowingiCloudError = true
      return nil
    } else {
      isAuthenticating = true
      return nil
    }
  }
}

private extension Project.PublishingMenu {
  @MainActor func loadIsPublished() async {
    await printError {
      do {
        isPublished = try await communityController.databaseService.exists(SharedProject.self, with: project.id)
      } catch let error as DatabaseError where error.hasDescription { self.error = error }
    }
  }

  @MainActor func updateIsPublished(on event: DatabaseEvent) async {
    switch event {
    case let .inserted(type, id) where type == SharedProject.self && id as? SharedProject.ID == project.id:
      isPublished = true
    case let .deleted(type, id) where type == SharedProject.self && id as? SharedProject.ID == project.id:
      isPublished = false
    case .status, .remote:
      await loadIsPublished()
    default: break
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct PublishingMenu_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      Text("")
        .toolbar { Project.PublishingMenu(.example) }
    }
  }
}
#endif
