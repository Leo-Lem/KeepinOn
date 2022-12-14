// Created by Leopold Lemmermann on 14.12.22.

import Errors
import LeosMisc
import SwiftUI

struct ChangeNameMenu: View {
  let name: String
  let save: (String) async throws -> Void

  var body: some View {
    TextField.WithConfirm(
      name ??? String(localized: "ACCOUNT_CHANGE_DISPLAYNAME"), text: $newName,
      confirmIsDisabled: newName.count < 3
    ) {
      await printError {
        try await save(newName)
        newName = ""
      }
    }
    .autocorrectionDisabled()
    .textFieldStyle(.roundedBorder)
    .textCase(nil)
    .accessibilityLabel("ACCOUNT_CHANGE_DISPLAYNAME")
  }

  @State private var newName = ""

  init(_ name: String, save: @escaping (String) async throws -> Void) { (self.name, self.save) = (name, save) }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ChangeUsernameView_Previews: PreviewProvider {
  static var previews: some View {
    ChangeNameMenu(User.example.name) { _ in
      try? await Task.sleep(for: .seconds(1))
    }
  }
}
#endif
