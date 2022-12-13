//	Created by Leopold Lemmermann on 05.12.22.

import AuthenticationUI
import Errors
import LeosMisc
import LocalAuthentication
import SwiftUI

struct AccountMenu: View {
  var body: some View {
    Label("ACCOUNT_TITLE", systemImage: "person.crop.circle")
      .platformAdjustedMenu {
        switch mainState.authenticationState {
        case .notAuthenticated: isAuthenticating = true
        case .authenticatedWithoutiCloud: mainState.showPresentation(alert: .noiCloud)
        case .authenticated: Task(priority: .userInitiated) { await unlockEditing() }
        }
      } actions: {
        AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
          if case .authenticated = mainState.authenticationState { await unlockEditing() } else {
            mainState.showPresentation(alert: .noiCloud)
          }
        } label: {
          Label("ACCOUNT_TITLE", systemImage: "person.crop.circle")
        }
        
        Button { isDeletingAccount = true } label: {
          Label("DELETE_ACCOUNT", systemImage: "person.crop.circle.badge.minus")
        }

        Button { printError(mainState.authService.logout) } label: {
          Label("ACCOUNT_LOGOUT", systemImage: "person.crop.circle.badge.xmark")
        }
      }
      .popover(isPresented: $isAuthenticating, content: AuthenticationView.init)
      .popover(isPresented: $isEditingUser) { mainState.authenticationState.user?.editingView() }
      .alert("DELETE_ACCOUNT_ALERT_TITLE", isPresented: $isDeletingAccount) {
        Button("DELETE_ACCOUNT", role: .destructive) {
          Task(priority: .userInitiated) {
            await printError {
              do {
                guard let id = mainState.authenticationState.id else { return }
                try await mainState.authService.deregister()
                try await mainState.publicDBService.delete(User.self, with: id)
              } catch let error as AuthenticationError where error.hasDescription { self.error = error }
            }
          }
        }
      } message: { Text("DELETE_ACCOUNT_ALERT_MESSAGE") }
      .alert(isPresented: Binding(item: $error), error: error) {}
      .accessibilityIdentifier("account-action")
  }

  @State private var isAuthenticating = false
  @State private var isDeletingAccount = false
  @State private var isEditingUser = false
  @State private var error: AuthenticationError?
  @SceneStorage("editingIsUnlocked") private var editingIsUnlocked = false

  @EnvironmentObject private var mainState: MainState

  @MainActor func unlockEditing() async {
    await printError {
      guard case .authenticated = mainState.authenticationState else { return }

      if editingIsUnlocked { return isEditingUser = true }

      editingIsUnlocked = try await LAContext().evaluatePolicy(
        .deviceOwnerAuthentication,
        localizedReason: String(localized: "AUTHENTICATE_TO_EDIT_ACCOUNT")
      )

      if editingIsUnlocked { isEditingUser = true }
    }
  }
}

struct AccountMenu_Previews: PreviewProvider {
  static var previews: some View {
    AccountMenu()
  }
}
