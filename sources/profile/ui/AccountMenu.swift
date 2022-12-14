//	Created by Leopold Lemmermann on 05.12.22.

import AuthenticationUI
import ComposableArchitecture
import Errors
import LeosMisc
import SwiftUI

struct AccountMenu: View {
  var body: some View {
    WithViewStore(store) { $0.account.id } send: { (_: ViewAction) in .account(.loadID) } content: { currentUserID in
      Button {
        if currentUserID.state == nil { isAuthenticating = true } else { isSelecting = true }
      } label: {
        Label(
          String(localized: currentUserID.state.flatMap { "LOGGED_IN_AS \($0)" } ?? "ACCOUNT_LOGIN"),
          systemImage: "person.crop.circle"
        )
      }
      .popover(isPresented: $isSelecting) {
        VStack {
          AccountActionButton.changePIN
          Divider()
          AccountActionButton.delete
          Divider()
          AccountActionButton.logout
        }
        .padding()
        .buttonStyle(.borderless)
        .presentationDetents([.height(150)])
      }
      .popover(isPresented: $isAuthenticating) { AuthenticationView(service: authService) }
      .task { await currentUserID.send(.load).finish() }
      .animation(.default, value: currentUserID.state)
      .accessibilityIdentifier("account-menu")
    }
  }

  @State private var isAuthenticating = false
  @State private var isSelecting = false
  @EnvironmentObject private var store: StoreOf<MainReducer>
  @Dependency(\.authenticationService) private var authService

  enum ViewAction { case load }
}

// MARK: - PREVIEWS

struct AccountMenu_Previews: PreviewProvider {
  static var previews: some View {
    AccountMenu()
  }
}
