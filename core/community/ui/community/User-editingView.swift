//	Created by Leopold Lemmermann on 27.10.22.

import Errors
import LeosMisc
import Previews
import RemoteDatabaseService
import SwiftUI

extension User {
  func editingView() -> some View { EditingView(self) }

  struct EditingView: View {
    var body: some View {
      VStack {
        HStack {
          VStack(alignment: .leading) {
            Text(user.label + " ")
              .font(.default(.title1))
              .lineLimit(1)
            Text(
              user.idLabel.prefix(10) +
                (user.idLabel.count > 10 ? "..." : "")
            ).font(.default(.subheadline))
          }
        }
        .bold()
        .foregroundColor(user.color)
        .padding()
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityValue("A11Y_USER \(user.label) \(String(user.idLabel.prefix(10)))")

        Form {
          Section("ACCOUNT_CHANGE_DISPLAYNAME") {
            VStack {
              TextField(user.name ??? String(localized: "ACCOUNT_CHANGE_DISPLAYNAME"), text: $name)
                .textFieldStyle(.roundedBorder)
                .textCase(nil)
                .accessibilityLabel("ACCOUNT_CHANGE_DISPLAYNAME")

              Button(action: updateUser) {
                Text("CONFIRM")
                  .frame(maxWidth: .infinity, minHeight: 44)
                  .background(name.count < 3 ? Color.gray : Color.accentColor)
                  .foregroundColor(.white)
                  .clipShape(Capsule())
                  .contentShape(Capsule())
              }
              .disabled(name.count < 3)
            }
            .disabled(editingDisabled, message: "SIGN_INTO_ICLOUD")
          }

          Section("ACCOUNT_SELECT_COLOR") {
            $user.colorID.selectionGrid
              .onChange(of: user.colorID) { _ in updateUser() }
              .accessibilityElement(children: .ignore)
              .accessibilityLabel("ACCOUNT_SELECT_COLOR")
              .accessibilityValue(user.colorID.a11y)
              .disabled(editingDisabled, message: "SIGN_INTO_ICLOUD")
          }
        }
        .scrollContentBackground(.hidden)
        .animation(.default, value: editingDisabled)
        .accessibilityLabel("A11Y_CUSTOMIZE_ACCOUNT")
      }
      .overlay(alignment: .topTrailing) {
        if vSize == .compact {
          Button("DISMISS") { dismiss() }
            .buttonStyle(.borderedProminent)
            .padding()
        }
      }
    }

    @EnvironmentObject private var mainState: MainState
    @Environment(\.dismiss) var dismiss
    @Environment(\.verticalSizeClass) var vSize
    
    @State private var user: User
    @State private var name = ""

    init(_ user: User) { _user = State(initialValue: user) }
  }
}

private extension User.EditingView {
  var editingDisabled: Bool { mainState.remoteDBService.status == .readOnly }

  func updateUser() {
    guard mainState.user != nil else { return }

    Task(priority: .userInitiated) {
      try await mainState.remoteDBService.publish(user)
      name = ""
    }
  }

//  func updatePIN(_ newPIN: Credential.PIN) async throws {
//    guard user != nil else { return }
//
//      try await mainState.authService.changePIN(newPIN)
//  }

//  func deleteAccount() async throws {
//    try await mainState.authService.deregister()
//  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct UserEditingView_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        User.EditingView(.example)
          .previewDisplayName("Bare")

        User.example.editingView()
          .previewInSheet()
      }
      .configureForPreviews()
    }
  }
#endif
