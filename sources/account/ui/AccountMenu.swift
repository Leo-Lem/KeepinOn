//	Created by Leopold Lemmermann on 05.12.22.

import AuthenticationUI
import Errors
import LeosMisc
import LocalAuthentication
import SwiftUI

struct AccountMenu: View {
  var body: some View {
    Label(accountController.id ?? String(localized: "ACCOUNT_LOGIN"), systemImage: "person.crop.circle")
      .platformAdjustedMenu { primaryAction() } actions: {
        if accountController.isAuthenticated { actions() }
      }
    #if os(iOS)
      .confirmationDialog("ACCOUNT_TITLE", isPresented: $isSelecting, actions: actions)
    #endif
      .popover(isPresented: $isAuthenticating) { AuthenticationView(service: accountController.authService) }
      .popover(isPresented: $isEditingUser) { accountController.user?.editingView() }
      .popover(isPresented: $isChangingPIN) { ChangePINView(service: accountController.authService)}
      .alert("CANT_CONNECT_TO_ICLOUD_TITLE", isPresented: $isShowingiCloudError) {} message: {
        Text("CANT_CONNECT_TO_ICLOUD_MESSAGE")
      }
      .alert("DELETE_ACCOUNT_ALERT_TITLE", isPresented: $isDeletingAccount) {
        Button("DELETE_ACCOUNT", role: .destructive) {
          Task(priority: .userInitiated) { await deleteAccount() }
        }
        .accessibilityIdentifier("confirm-account-delete")
      } message: { Text("DELETE_ACCOUNT_ALERT_MESSAGE") }
      .alert(isPresented: Binding(item: $error), error: error) {}
      .accessibilityIdentifier("account-menu")
  }

  @State private var isChangingPIN = false

  // modals
  @State private var isSelecting = false
  @State private var isAuthenticating = false
  @State private var isEditingUser = false

  // alerts
  @State private var isDeletingAccount = false
  @State private var isShowingiCloudError = false
  @State private var error: AuthenticationError?

  @SceneStorage("editingIsUnlocked") private var editingIsUnlocked = false

  @EnvironmentObject private var accountController: AccountController

  @ViewBuilder private func actions() -> some View {
    Button("ACCOUNT_EDIT") { openEditing() }
      .accessibilityIdentifier("account-edit")
    Button("CHANGE_PIN") { isChangingPIN = true }
      .accessibilityIdentifier("account-change-pin")
    Button("DELETE_ACCOUNT") { isDeletingAccount = true }
      .accessibilityIdentifier("account-delete")
    Button("ACCOUNT_LOGOUT") { printError(accountController.authService.logout) }
      .accessibilityIdentifier("account-logout")
  }

  @MainActor private func openEditing() {
    if accountController.canPublish {
      Task(priority: .userInitiated) { await unlockEditing() }
    } else {
      isShowingiCloudError = true
    }
  }
  
  @MainActor private func primaryAction() {
    if !accountController.isAuthenticated { isAuthenticating = true } else {
      #if os(iOS)
        isSelecting = true
      #elseif os(macOS)
        openEditing()
      #endif
    }
  }

  @MainActor private func unlockEditing() async {
    await printError {
      guard accountController.isAuthenticated else { return }

      if editingIsUnlocked { return isEditingUser = true }
      editingIsUnlocked = try await LAContext().evaluatePolicy(
        .deviceOwnerAuthentication,
        localizedReason: String(localized: "AUTHENTICATE_TO_EDIT_ACCOUNT")
      )
      if editingIsUnlocked { isEditingUser = true }
    }
  }

  @MainActor private func deleteAccount() async {
    await printError {
      do {
        guard accountController.isAuthenticated else { return }

        if accountController.canPublish {
          try await accountController.authService.deregister()
        } else {
          isShowingiCloudError = true
        }
      } catch let error as AuthenticationError where error.hasDescription { self.error = error }
    }
  }
}

struct AccountMenu_Previews: PreviewProvider {
  static var previews: some View {
    AccountMenu()
  }
}
