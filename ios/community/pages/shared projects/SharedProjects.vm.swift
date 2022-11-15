//	Created by Leopold Lemmermann on 07.10.22.

import Concurrency
import Foundation

extension CommunityView {
  @MainActor final class ViewModel: KeepinOn.ViewModel {
    @Published private(set) var loadState: LoadingState<Project.Shared.WithOwner> = .idle

    @Published private(set) var user: User?

    override init(appState: AppState) {
      super.init(appState: appState)

      updateLoadState()
      updateUser()

      tasks.add(
        remoteDBService.didChange.getTask(operation: updateLoadState),
        authService.didChange.getTask(operation: updateUser)
      )
    }
  }
}

extension CommunityView.ViewModel {
  func refresh() {
    updateLoadState()
  }
}

private extension CommunityView.ViewModel {
  func updateUser() {
    if case let .authenticated(user) = authService.status {
      self.user = user
    } else {
      user = nil
    }
  }
  
  func updateLoadState(_: RemoteDBChange? = nil) {
    tasks["updateState"] = Task(priority: .userInitiated) {
      do {
        try await appState.showErrorAlert {
          for try await projects in remoteDBService.fetch(
            Query<Project.Shared>(true, options: .init(batchSize: 5))
          ) {
            try await projects.forEach { project in
              try await project
                .attachOwner(remoteDBService)
                .flatMap { loadState.add($0) }
            }
          }
          
          loadState.finish {}
        }
      } catch {
        loadState.finish { throw error }
      }
    }
  }
}
