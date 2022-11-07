//	Created by Leopold Lemmermann on 25.10.22.

import Foundation

extension SharedProjectView {
  final class ViewModel: KeepinOn.ViewModel {
    let project: Project.Shared

    @Published private(set) var itemsLoadState: LoadState<Item.Shared> = .idle
    @Published private(set) var commentsLoadState: LoadState<Comment> = .idle

    init(project: Project.Shared, appState: AppState) {
      self.project = project

      super.init(appState: appState)

      updateState()

      tasks.add(publicDatabaseService.didChange.getTask(with: updateState))
    }
  }
}

extension SharedProjectView.ViewModel {
  func refresh() {
    updateState()
  }

  func startAuthentication() {
    routingService.route(to: Sheet.account)
  }

  func postComment(text: String) async throws {
    guard let user = user else { return }
    let text = text.trimmingCharacters(in: .whitespacesAndNewlines)
    let comment = Comment(project: project, postedBy: user, content: text)

    try await appState.showErrorAlert {
      try await publicDatabaseService.publish(comment)
      try await awardService.commentsPosted(1)
    }
  }

  func delete(_ comment: Comment) async {
    guard user != nil, user == comment.postedBy else { return }
    await printError {
      try await appState.showErrorAlert {
        try await publicDatabaseService.unpublish(comment)
      }
    }
  }

  var user: User? {
    if case let .authenticated(user) = authenticationService.status {
      return user
    } else {
      return nil
    }
  }

  var canPostComments: Bool { user != nil }
}

private extension SharedProjectView.ViewModel {
  func updateState() {
    updateItemsState()
    updateCommentsState()
  }

  func updateItemsState() {
    tasks.add(for: "updateItemsState", Task(priority: .userInitiated) {
      do {
        try await appState.showErrorAlert {
          try await publicDatabaseService.fetchReferencesTo(project)
            .receive(on: RunLoop.main)
            .useValues { newValue in
              await MainActor.run { [weak self] in
                self?.itemsLoadState.add(elements: newValue)
              }
            } finally: {
              await MainActor.run { [weak self] in
                self?.itemsLoadState.setLoaded()
              }
            }
        }
      } catch {
        self.itemsLoadState = .failed(error)
      }
    })
  }

  func updateCommentsState() {
    tasks.add(for: "updateCommentsState", Task(priority: .userInitiated) {
      do {
        try await appState.showErrorAlert {
          try await publicDatabaseService.fetchReferencesTo(project)
            .receive(on: RunLoop.main)
            .useValues { newValue in
              await MainActor.run { [weak self] in
                self?.commentsLoadState.add(elements: newValue)
              }
            } finally: {
              await MainActor.run { [weak self] in
                self?.commentsLoadState.setLoaded()
              }
            }
        }
      } catch {
        self.commentsLoadState = .failed(error)
      }
    })
  }
}
