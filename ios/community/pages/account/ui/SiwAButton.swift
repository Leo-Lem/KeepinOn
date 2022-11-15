//	Created by Leopold Lemmermann on 31.10.22.

import AuthenticationServices
import Errors
import SwiftUI

struct SiwAButton: View {
  @EnvironmentObject var appState: AppState

  var body: some View {
    SignInWithAppleButton(onRequest: handleRequest, onCompletion: handleResult)
  }
}

extension SiwAButton {
  private var authService: AuthService {
    appState.authService
  }

  private func handleRequest(_ request: ASAuthorizationAppleIDRequest) {
    request.requestedScopes = [.fullName]
  }

  private func handleResult(_ result: Result<ASAuthorization, Error>) {
    switch result {
    case let .success(auth):
      if let appleID = auth.credential as? ASAuthorizationAppleIDCredential {
        let credential = Credential(userID: appleID.user, pin: nil)

        Task(priority: .userInitiated) {
          await printError {
            do {
              try await authService.login(credential)
            } catch let error as AuthError {
              if case .login(.unknownID) = error {
                var user = try await authService.register(credential)
                user.name ?= appleID.fullName?.formatted()
                try await authService.update(user)
              }
            }
          }
        }
      }
    case let .failure(error):
      if
        let error = error as? ASAuthorizationError,
        1000 ... 1001 ~= error.errorCode
      {
        appState.routingService.dismiss(.sheet())
      } else {
        print(error.localizedDescription)
      }
    }
  }
}
