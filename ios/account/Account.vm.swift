//	Created by Leopold Lemmermann on 07.10.22.

import Foundation

extension AccountView {
  @MainActor final class ViewModel: KeepinOn.ViewModel {
    @Published var authenticationStatus: AuthStatus = .notAuthenticated

    override init(appState: AppState) {
      super.init(appState: appState)

      updateStatus()

      tasks.add(authService.didChange.getTask(with: updateStatus))
    }
  }
}

extension AccountView.ViewModel {
  func cancel() {
    routingService.dismiss(.sheet())
  }

  func register(id: String, pin: String, name: String) async throws {
    try await appState.showErrorAlert {
      let credential = Credential(userID: id, pin: pin)
      var user = try await authService.register(credential)
      user.name = name
      try await authService.update(user)
    }
  }

  func login(id: String, pin: String) async throws {
    try await appState.showErrorAlert {
      let credential = Credential(userID: id, pin: pin)
      try await authService.login(credential)
    }
  }

  func update(_ user: User) async throws {
    try await appState.showErrorAlert {
      guard case .authenticated = authenticationStatus else { return }

      try await authService.update(user)
    }
  }

  func update(_ pin: String) async throws {
    try await appState.showErrorAlert {
      guard case let .authenticated(user) = authenticationStatus else { return }

      let credential = Credential(userID: user.id, pin: pin)
      try await authService.update(credential)
    }
  }

  func logout() {
    authService.logout()
  }

  func deleteAccount() async throws {
    try await appState.showErrorAlert {
      guard case .authenticated = authenticationStatus else { return }

      try await authService.deleteAccount()
    }
  }
}

private extension AccountView.ViewModel {
  func updateStatus() {
    authenticationStatus = authService.status
  }
}
