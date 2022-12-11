//	Created by Leopold Lemmermann on 27.10.22.

import Concurrency
import Errors
import LeosMisc
import Previews
import SwiftUI
import Colors

extension User {
  func editingView() -> some View { EditingView(self) }

  struct EditingView: View {
    let user: User
    
    var body: some View {
      VStack {
        header()

        Form {
          Section("ACCOUNT_CHANGE_DISPLAYNAME") {
            VStack {
              TextField(user.name ??? String(localized: "ACCOUNT_CHANGE_DISPLAYNAME"), text: $name)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                .textCase(nil)
                .accessibilityLabel("ACCOUNT_CHANGE_DISPLAYNAME")
            }
            .disabled(editingIsDisabled, message: "SIGN_INTO_ICLOUD")

            confirmButton()
              .buttonStyle(.borderless)
          }

          Section("ACCOUNT_SELECT_COLOR") {
            $colorID.selectionGrid
              .onChange(of: colorID) { _ in Task(priority: .userInitiated) { await saveUser() } }
              .accessibilityElement(children: .ignore)
              .accessibilityLabel("ACCOUNT_SELECT_COLOR")
              .accessibilityValue(user.colorID.a11y)
              .disabled(editingIsDisabled, message: "SIGN_INTO_ICLOUD")
          }
        }
        .scrollContentBackground(.hidden)
        .accessibilityLabel("A11Y_CUSTOMIZE_ACCOUNT")
        .formStyle(.grouped)
      }
      #if os(iOS)
      .compactDismissButton()
      #endif
    }
    
    @State private var colorID: ColorID
    @State private var name = ""
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var mainState: MainState
    
    init(_ user: User) {
      self.user = user
      _colorID = State(initialValue: user.colorID)
    }
  }
}

private extension User.EditingView {
  func header() -> some View {
    HStack {
      VStack(alignment: .leading) {
        Text(user.label + " ")
          .font(.default(.title1))
          .lineLimit(1)

        Text(user.idLabel.prefix(10) + (user.idLabel.count > 10 ? "..." : ""))
          .font(.default(.subheadline))
      }
    }
    .bold()
    .foregroundColor(user.color)
    .padding()
    .frame(maxWidth: .infinity)
    .accessibilityElement(children: .ignore)
    .accessibilityValue("A11Y_USER \(user.label) \(String(user.idLabel.prefix(10)))")
  }

  func confirmButton() -> some View {
    AsyncButton(indicatorStyle: .edge(.trailing), taskPriority: .userInitiated) {
      await saveUser()
    } label: {
      Text("CONFIRM")
        .frame(maxWidth: .infinity, minHeight: 44)
        .background(name.count < 3 ? Color.gray : .accentColor)
        .foregroundColor(.white)
        .clipShape(Capsule())
        .contentShape(Capsule())
    }
    .disabled(name.count < 3)
  }
}

private extension User.EditingView {
  var editingIsDisabled: Bool {
    if case .authenticatedWithoutiCloud = mainState.authenticationState { return true } else { return false }
  }
  
  @MainActor func saveUser() async {
    await printError {
      guard case .authenticated = mainState.authenticationState else { return dismiss() }

      try await mainState.publicDBService.modify(User.self, with: user.id) { mutable in
        mutable.name = name
        mutable.colorID = colorID
      }
      
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
