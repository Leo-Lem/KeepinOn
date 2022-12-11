//	Created by Leopold Lemmermann on 25.10.22.

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
        AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
          await publish()
        } label: {
          isPublished ?
            Label("REPUBLISH_PROJECT", systemImage: "arrow.clockwise.icloud") :
            Label("PUBLISH_PROJECT", systemImage: "icloud.and.arrow.up")
        }

        if isPublished {
          AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
            await unpublish()
          } label: {
            Label("UNPUBLISH_PROJECT", systemImage: "xmark.icloud")
          }
        }
      }
      .animation(.default, value: isPublished)
      .accessibilityElement(children: .contain)
      .popover(isPresented: $isAuthenticating, content: AuthenticationView.init)
      .task {
        await loadIsPublished()
        tasks["updateIsPublished"] = Task(priority: .background) { await updateIsPublished() }
      }
    }

    @State private var isPublished: Bool?

    @State private var isAuthenticating = false

    @State private var tasks = Tasks()
    @State private var hapticsService = CoreHapticsService()

    @EnvironmentObject private var mainState: MainState

    init(_ project: Project) { self.project = project }
  }
}

private extension Project.PublishingMenu {
  func publish() async {
    await printError {
      switch mainState.authenticationState {
      case .notAuthenticated:
        isAuthenticating = true
      case .authenticatedWithoutiCloud:
        mainState.showPresentation(alert: .noiCloud)
      case let .authenticated(user):
        try await mainState.displayError {
          try await mainState.publicDBService.insert(
            try await project.items.compactMap { id in
              try await mainState.privateDBService.fetch(with: id).flatMap(SharedItem.init)
            }
          ).collect()

          try await mainState.publicDBService.insert(SharedProject(project, owner: user.id))

          hapticsService?.play(.taDa)
        }
      }
    }
  }

  @MainActor func unpublish() async {
    await printError {
      switch mainState.authenticationState {
      case .notAuthenticated:
        isAuthenticating = true
      case .authenticatedWithoutiCloud:
        mainState.showPresentation(alert: .noiCloud)
      case .authenticated:
        try await mainState.displayError {
          try await mainState.publicDBService.delete(SharedProject.self, with: project.id)
          isPublished = nil
        }
      }
    }
  }
}

private extension Project.PublishingMenu {
  @MainActor func loadIsPublished() async {
    await printError {
      try await mainState.displayError {
        isPublished = try await mainState.publicDBService.exists(SharedProject.self, with: project.id)
      }
    }
  }

  @MainActor func updateIsPublished() async {
    for await event in mainState.publicDBService.events {
      switch event {
      case let .inserted(type, id) where type == SharedProject.self:
        if let id = id as? SharedProject.ID, id == project.id { isPublished = true }
      case let .deleted(type, id) where type == SharedProject.self:
        if let id = id as? SharedProject.ID, id == project.id { isPublished = false }
      case .status, .remote:
        await loadIsPublished()
      default: break
      }
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
    .configureForPreviews()
  }
}
#endif
