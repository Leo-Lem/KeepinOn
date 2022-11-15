//	Created by Leopold Lemmermann on 25.10.22.

import Concurrency
import Errors
import Foundation

extension SharedProjectView {
  final class ViewModel: KeepinOn.ViewModel {
    let project: Project.Shared

    @Published private(set) var itemsLoadState: LoadingState<Item.Shared> = .idle
    @Published private(set) var commentsLoadState: LoadingState<Comment> = .idle

    init(project: Project.Shared, appState: AppState) {
      self.project = project

      super.init(appState: appState)

      updateLoadStates()

      tasks.add(remoteDBService.didChange.getTask(operation: updateLoadStates))
    }
  }
}

extension SharedProjectView.ViewModel {
  func refresh() {
    updateLoadStates()
  }

  func startAuthentication() {
    routingService.route(to: Sheet.account)
  }

  func postComment(text: String) async throws {
    guard let user = user else { return }
    let text = text.trimmingCharacters(in: .whitespacesAndNewlines)
    let comment = Comment(content: text, project: project.id, poster: user.id)

    try await appState.showErrorAlert {
      try await remoteDBService.publish(comment)
      try await awardService.postedComment()
    }
  }

  func delete(_ comment: Comment) async {
    guard let user = user, user.id == comment.poster else { return }
    await printError {
      try await appState.showErrorAlert {
        try await remoteDBService.unpublish(comment)
      }
    }
  }

  var user: User? {
    if case let .authenticated(user) = authService.status {
      return user
    } else {
      return nil
    }
  }

  var canPostComments: Bool { user != nil }
}

private extension SharedProjectView.ViewModel {
  func updateLoadStates(_ change: RemoteDBChange? = nil) {
    updateCommentsLoadState(change)
    updateCommentsLoadState(change)
  }

  func updateItemsLoadState(_: RemoteDBChange? = nil) {
    tasks["updateItemsState"] = Task(priority: .userInitiated) {
      do {
        try await appState.showErrorAlert {
          for try await item in remoteDBService.fetch(
            Query<Item.Shared>(true, options: .init(batchSize: 5))
          ) {
            itemsLoadState.add(item)
          }
        }
        itemsLoadState.finish {}
      } catch {
        itemsLoadState.finish { throw error }
      }
    }
  }

  func updateCommentsLoadState(_: RemoteDBChange? = nil) {
    tasks["updateCommentsState"] = Task(priority: .userInitiated) {
      do {
        try await appState.showErrorAlert {
          for try await comment in remoteDBService.fetch(
            Query<Comment>(true, options: .init(batchSize: 5))
          ) {
            commentsLoadState.add(comment)
          }
        }
        commentsLoadState.finish {}
      } catch {
        commentsLoadState.finish { throw error }
      }
    }
  }
}
