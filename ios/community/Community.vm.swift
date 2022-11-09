//	Created by Leopold Lemmermann on 07.10.22.

import Foundation

extension CommunityView {
  @MainActor final class ViewModel: KeepinOn.ViewModel {
    @Published private(set) var loadState: LoadState<Project.Shared> = .idle

    @Published private(set) var user: User?

    override init(appState: AppState) {
      super.init(appState: appState)

      updateLoadState()
      updateUser()

      tasks.add(
        publicDatabaseService.didChange.getTask(with: updateLoadState),
        authService.didChange.getTask(with: updateUser)
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
  func updateLoadState() {
    tasks.add(for: "updateState", Task(priority: .userInitiated) {
      do {
        try await appState.showErrorAlert {
          let query = Query<Project.Shared>(true, options: .init(maxItems: 10))
          try await publicDatabaseService.fetch(query)
            .receive(on: RunLoop.main)
            .useValues { newValue in
              await MainActor.run { [weak self] in
                self?.loadState.add(elements: newValue)
              }
            } finally: {
              await MainActor.run { [weak self] in
                self?.loadState.setLoaded()
              }
            }
        }
      } catch {
        self.loadState = .failed(error)
      }
    })
  }

  func updateUser() {
    if case let .authenticated(user) = authService.status {
      self.user = user
    } else {
      user = nil
    }
  }
}
