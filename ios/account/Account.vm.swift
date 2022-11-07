//	Created by Leopold Lemmermann on 07.10.22.

import Foundation

extension AccountView {
  @MainActor final class ViewModel: KeepinOn.ViewModel {
    @Published var authenticationStatus: AuthStatus = .notAuthenticated

    override init(appState: AppState) {
      super.init(appState: appState)

      updateStatus()

      tasks.add(authenticationService.didChange.getTask(with: updateStatus))
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
      var user = try await authenticationService.register(credential)
      user.name = name
      try await authenticationService.update(user)
    }
  }

  func login(id: String, pin: String) async throws {
    try await appState.showErrorAlert {
      let credential = Credential(userID: id, pin: pin)
      try await authenticationService.login(credential)
    }
  }

  func update(_ user: User) async throws {
    try await appState.showErrorAlert {
      guard case .authenticated = authenticationStatus else { return }

      try await authenticationService.update(user)
    }
  }

  func update(_ pin: String) async throws {
    try await appState.showErrorAlert {
      guard case let .authenticated(user) = authenticationStatus else { return }

      let credential = Credential(userID: user.id, pin: pin)
      try await authenticationService.update(credential)
    }
  }

  func logout() {
    authenticationService.logout()
  }

  func deleteAccount() async throws {
    try await appState.showErrorAlert {
      guard case .authenticated = authenticationStatus else { return }

      try await authenticationService.deleteAccount()
    }
  }
}

private extension AccountView.ViewModel {
  func updateStatus() {
    authenticationStatus = authenticationService.status
  }
}
