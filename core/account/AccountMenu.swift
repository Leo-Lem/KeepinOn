//	Created by Leopold Lemmermann on 05.12.22.

import Errors
import LeosMisc
import LocalAuthentication
import SwiftUI

struct AccountMenu: View {
  var body: some View {
    switch mainState.authenticationState {
    case .notAuthenticated:
      Button { isAuthenticating = true } label: {
        Label("ACCOUNT_TITLE", systemImage: "person.crop.circle")
      }
      .popover(isPresented: $isAuthenticating, content: AuthenticationView.init)

    case .authenticatedWithoutiCloud, .authenticated:
      #if os(iOS)
      Menu {
        AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
          Task(priority: .userInitiated) {
            if case .authenticated = mainState.authenticationState { await unlockEditing() } else {
              mainState.showPresentation(alert: .noiCloud)
            }
          }
        } label: {
          Label("ACCOUNT_TITLE", systemImage: "person.crop.circle")
        }

        Button { printError(mainState.authService.logout) } label: {
          Label("ACCOUNT_LOGOUT", systemImage: "person.fill.xmark")
        }
      } label: {
        Label("ACCOUNT_TITLE", systemImage: "person.crop.circle")
      } primaryAction: {
        Task(priority: .userInitiated) {
          if case .authenticated = mainState.authenticationState { await unlockEditing() } else {
            mainState.showPresentation(alert: .noiCloud)
          }
        }
      }
      .labelStyle(.titleAndIcon)
      #elseif os(macOS)
      AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
        Task(priority: .userInitiated) {
          if case .authenticated = mainState.authenticationState { await unlockEditing() } else {
            mainState.showPresentation(alert: .noiCloud)
          }
        }
      } label: {
        Label("ACCOUNT_TITLE", systemImage: "person.crop.circle")
      }
      .contextMenu {
        AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
          Task(priority: .userInitiated) {
            if case .authenticated = mainState.authenticationState { await unlockEditing() } else {
              mainState.showPresentation(alert: .noiCloud)
            }
          }
        } label: {
          Label("ACCOUNT_TITLE", systemImage: "person.crop.circle")
        }

        Button { printError(mainState.authService.logout) } label: {
          Label("ACCOUNT_LOGOUT", systemImage: "person.fill.xmark")
        }
      }
      #endif
    }
  }

  @State private var isAuthenticating = false
  @SceneStorage("editingIsUnlocked") private var editingIsUnlocked = false

  @EnvironmentObject private var mainState: MainState

  @MainActor func unlockEditing() async {
    await printError {
      guard case let .authenticated(user) = mainState.authenticationState else { return }

      if editingIsUnlocked { return mainState.showPresentation(detail: .editUser(user)) }

      editingIsUnlocked = try await LAContext().evaluatePolicy(
        .deviceOwnerAuthentication,
        localizedReason: String(localized: "AUTHENTICATE_TO_EDIT_ACCOUNT")
      )

      if editingIsUnlocked { return mainState.showPresentation(detail: .editUser(user)) }
    }
  }
}

struct AccountMenu_Previews: PreviewProvider {
  static var previews: some View {
    AccountMenu()
  }
}
