//	Created by Leopold Lemmermann on 27.10.22.

import Colors
import Concurrency
import Errors
import LeosMisc
import Previews
import SwiftUI

extension User {
  func editingView() -> some View { EditingView(self) }

  struct EditingView: View {
    var body: some View {
      VStack {
        header()

        Form {
          Section("ACCOUNT_CHANGE_DISPLAYNAME") {
            TextField(user.name ??? String(localized: "ACCOUNT_CHANGE_DISPLAYNAME"), text: $name)
              .autocorrectionDisabled()
              .textFieldStyle(.roundedBorder)
              .textCase(nil)
              .accessibilityLabel("ACCOUNT_CHANGE_DISPLAYNAME")
              .disabled(!accountService.canPublish && accountService.isAuthenticated, message: "SIGN_INTO_ICLOUD")

            confirmButton()
              .buttonStyle(.borderless)
              .disabled(!accountService.canPublish && accountService.isAuthenticated, message: "SIGN_INTO_ICLOUD")
          }

          Section("ACCOUNT_SELECT_COLOR") {
            ColorID.SelectionGrid(
              Binding { user.colorID } set: { newValue in
                Task(priority: .userInitiated) {
                  savingColorID = true
                  await saveColorID(newValue)
                  savingColorID = false
                }
              }
            )
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("ACCOUNT_SELECT_COLOR")
            .accessibilityValue(user.colorID.a11y)
            .disabled(!accountService.canPublish && accountService.isAuthenticated, message: "SIGN_INTO_ICLOUD")
          }
        }
        .scrollContentBackground(.hidden)
        .accessibilityLabel("A11Y_CUSTOMIZE_ACCOUNT")
        .formStyle(.grouped)
      }
      .animation(.default, value: user)
      .onChange(of: accountService.user) { newUser in
        if let newUser { user = newUser } else { dismiss() }
      }
      #if os(iOS)
      .compactDismissButton()
      #endif
    }

    @State private var user: User
    @State private var name = ""
    @State private var savingColorID = false
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var accountService: AccountController
    @EnvironmentObject private var communityController: CommunityController

    init(_ user: User) { _user = State(initialValue: user) }
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

      if savingColorID {
        ProgressView()
      }
    }
    .animation(.default, value: savingColorID)
    .bold()
    .foregroundColor(user.color)
    .padding()
    .frame(maxWidth: .infinity)
    .accessibilityElement(children: .ignore)
    .accessibilityValue("A11Y_USER \(user.label) \(String(user.idLabel.prefix(10)))")
  }

  func confirmButton() -> some View {
    AsyncButton(indicatorStyle: .edge(.trailing), taskPriority: .userInitiated) { await saveName() } label: {
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
  @MainActor func saveColorID(_ colorID: ColorID) async {
    await printError {
      guard accountService.canPublish else { return dismiss() }
      try await communityController.databaseService.modify(User.self, with: user.id) { mutable in
        mutable.colorID = colorID
      }
    }
  }

  @MainActor func saveName() async {
    await printError {
      guard accountService.canPublish else { return dismiss() }
      try await communityController.databaseService.modify(User.self, with: user.id) { mutable in
        mutable.name = name
      }
      name = ""
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct UserEditingView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      User.EditingView(.example)

      User.example.editingView()
        .previewInSheet()
    }
  }
}
#endif
