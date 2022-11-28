//	Created by Leopold Lemmermann on 25.10.22.

import AuthenticationService
import Concurrency
import Errors
import RemoteDatabaseService
import SwiftUI

extension Project {
  func publishingMenu() -> some ToolbarContent { PublishingMenu(self) }

  struct PublishingMenu: ToolbarContent {
    let project: Project

    var body: some ToolbarContent {
      ToolbarItemGroup(placement: .navigationBarLeading) {
        Group {
          if let isPublished = self.isPublished {
            Button(action: publish) {
              isPublished ?
                Label("REPUBLISH_PROJECT", systemImage: "arrow.clockwise.icloud") :
                Label("PUBLISH_PROJECT", systemImage: "icloud.and.arrow.up")
            }
            .if(isPublishing) { $0.hidden().overlay(content: ProgressView.init) }
            .disabled(isUnpublishing)

            if isPublished {
              Button(action: unpublish) {
                Label("UNPUBLISH_PROJECT", systemImage: "xmark.icloud")
              }
              .if(isUnpublishing) { $0.hidden().overlay(content: ProgressView.init) }
              .disabled(isPublishing)
            }
          } else { ProgressView() }
        }
        .animation(.default, value: isPublished)
        .accessibilityElement(children: .contain)
        .if(mainState.remoteDBService.status == .available) { $0
          .sheet(isPresented: $isAuthenticating) { AuthenticationView(service: mainState.authService) }
        } else: { $0
          .alert("CANT_CONNECT_TO_ICLOUD_TITLE", isPresented: $isAuthenticating) {} message: {
            Text("CANT_CONNECT_TO_ICLOUD_MESSAGE")
          }
        }
        .task {
          await loadIsPublished()
          tasks.add(mainState.remoteDBService.didChange.getTask(operation: updateIsPublished))
        }
      }
    }

    @EnvironmentObject private var mainState: MainState

    @State private var isPublished: Bool?
    @State private var isPublishing = false
    @State private var isUnpublishing = false
    
    @State private var isAuthenticating = false

    private let tasks = Tasks()

    init(_ project: Project) { self.project = project }
  }
}

private extension Project.PublishingMenu {
  func publish() {
    guard let user = mainState.user else { return isAuthenticating = true }

    Task(priority: .userInitiated) {
      await printError {
        try await mainState.displayError {
          isPublishing = true

          try await mainState.remoteDBService.publish(
            project.items.compactMap { id in
              printError {
                try mainState.localDBService.fetch(with: id)
                  .flatMap(SharedItem.init)
              }
            }
          )
          
          try await mainState.remoteDBService.publish(SharedProject(project, owner: user.id))
          
          mainState.hapticsService?.play(.taDa)
          isPublishing = false
        }
      }
    }
  }

  func unpublish() {
    guard mainState.user != nil else { return isAuthenticating = true }

    Task(priority: .userInitiated) {
      await printError {
        try await mainState.displayError {
          isUnpublishing = true

          try await mainState.remoteDBService.unpublish(with: project.id, SharedProject.self)
          isPublished = nil
          isUnpublishing = false
        }
      }
    }
  }

  func loadIsPublished() async {
    await printError {
      do {
        try await mainState.displayError {
          isPublished = try await mainState.remoteDBService.exists(with: project.id, SharedProject.self)
        }
      } catch {
        isPublished = nil
        throw error
      }
    }
  }

  func updateIsPublished(_ change: RemoteDatabaseChange) async {
    switch change {
    case let .published(convertible):
      if let project = convertible as? SharedProject {
        isPublished = self.project.id == project.id
      }
    case let .unpublished(id, type):
      if
        type == SharedProject.self,
        let id = id as? UUID,
        project.id == id
      {
        isPublished = false
      }
    case .status, .remote:
      await loadIsPublished()
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct PublishingMenu_Previews: PreviewProvider {
    static var previews: some View {
      NavigationStack {
        Text("").toolbar { Project.PublishingMenu(.example) }
      }
      .configureForPreviews()
    }
  }
#endif
