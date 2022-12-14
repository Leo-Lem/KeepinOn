// Created by Leopold Lemmermann on 21.12.22.

import SwiftUI
import ComposableArchitecture
import AuthenticationUI

struct AccountActionButton: View {
  static let changePIN = Self(.changePIN)
  static let delete = Self(.delete)
  static let logout = Self(.logout)
  
  var body: some View {
    WithViewStore<ViewState, ViewAction, _>(store) { state in
      ViewState(canPublish: state.account.canPublish)
    } send: { action in
      switch action {
      case .logout: return .account(.logout)
      case .deleteAccount: return .account(.deleteAccount)
      }
    } content: { vm in
      switch kind {
      case .changePIN:
        ChangePINButton()
      case .delete:
        DeleteAccountButton(canPublish: vm.canPublish) {
          await vm.send(.deleteAccount).finish()
          // TODO: add authentication error to state and throw here
        }
      case .logout:
        LogoutButton { await vm.send(.logout).finish() }
      }
    }
  }
    
  @EnvironmentObject private var store: StoreOf<MainReducer>
  private let kind: Kind
  private init(_ kind: Kind) { self.kind = kind }
  
  enum Kind { case changePIN, delete, logout }
  struct ViewState: Equatable { var canPublish: Bool }
  enum ViewAction { case logout, deleteAccount }
}

extension AccountActionButton {
  struct ChangePINButton: View {
    var body: some View {
      Button("CHANGE_PIN") { isChangingPIN = true }
        .popover(isPresented: $isChangingPIN) { ChangePINView(service: authService) }
        .accessibilityIdentifier("account-change-pin")
    }
    
    @State private var isChangingPIN = false
    @Dependency(\.authenticationService) private var authService
  }
  
  struct DeleteAccountButton: View {
    let canPublish: Bool
    let deleteAccount: () async throws -> Void
    
    var body: some View {
      Button("DELETE_ACCOUNT", role: .destructive) { isDeletingAccount = true }
        .accessibilityIdentifier("account-delete")
        .alert("DELETE_ACCOUNT_ALERT_TITLE", isPresented: $isDeletingAccount) {
          Button("DELETE_ACCOUNT", role: .destructive) {
            if canPublish { delete() } else { isShowingiCloudWarning = true }
          }
          .accessibilityIdentifier("confirm-account-delete")
        } message: { Text("DELETE_ACCOUNT_ALERT_MESSAGE") }
        .alert("DELETE_ACCOUNT_WITHOUT_ICLOUD_TITLE", isPresented: $isShowingiCloudWarning) {
          Button("DELETE_ACCOUNT_ANYWAY", role: .destructive, action: delete)
        } message: { Text("DELETE_ACCOUNT_WITHOUT_ICLOUD_MESSAGE") }
        .alert(isPresented: Binding(item: $error), error: error) {}
    }
    
    @State private var isDeletingAccount = false
    @State private var isShowingiCloudWarning = false
    @State private var error: AuthenticationError?
    
    private func delete() {
      Task(priority: .userInitiated) {
        do {
          try await deleteAccount()
        } catch let error as AuthenticationError where error.hasDescription {
          self.error = error
        }
      }
    }
  }
  
  struct LogoutButton: View {
    let logout: () async -> Void
    
    var body: some View {
      Button("ACCOUNT_LOGOUT") {
        Task(priority: .userInitiated) {
          await logout()
          dismiss()
        }
      }
      .accessibilityIdentifier("account-logout")
    }
    
    @Environment(\.dismiss) private var dismiss
  }
}
