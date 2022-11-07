//	Created by Leopold Lemmermann on 27.10.22.

import SwiftUI

struct AuthenticationView: View {
  @Environment(\.colorScheme) var colorScheme

  let register: (String, String, String) async throws -> Void
  let login: (String, String) async throws -> Void

  var body: some View {
    Form {
      Text(isRegistering ? "AUTH_REGISTER" : "AUTH_LOGIN")
        .font(.default(.largeTitle))
        .frame(maxWidth: .infinity)

      Section {
        TextField("AUTH_USERID", text: $userID)
        SecureField("AUTH_PIN", text: $pin)
        if isRegistering {
          TextField("AUTH_NAME", text: $name)
            .transition(.slide)
        }
      }

      HStack {
        Button("AUTH_LOGIN") {
          Task(priority: .userInitiated) {
            isRegistering ?
              (isRegistering = false) :
              await submit()
          }
        }
        .buttonStyle(.borderedProminent)
        .frame(maxWidth: .infinity)
        .disabled(isSubmitDisabled && !isRegistering)

        Button("AUTH_REGISTER") {
          Task(priority: .userInitiated) {
            isRegistering ?
              await submit() :
              (isRegistering = true)
          }
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(.borderedProminent)
        .disabled(isSubmitDisabled && isRegistering)
      }

      Divider()

      SiwAButton()
        .aspectRatio(8/1, contentMode: .fit)

      Spacer()
    }
    .textFieldStyle(.roundedBorder)
    .formStyle(.columns)
    .scrollContentBackground(.hidden)
    .padding()
    .preferred(style: SheetViewStyle(size: .half))
  }

  @State private var isRegistering = false
  @State private var userID = ""
  @State private var pin = ""
  @State private var name = ""

  private var isSubmitDisabled: Bool {
    userID.count < 3 || pin.count < 4
  }

  private func submit() async {
    do {
      isRegistering ?
        try await register(userID, pin, name) :
        try await login(userID, pin)

      (userID, pin, name) = ("", "", "")
    } catch {}
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct AuthenticationView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      AuthenticationView { _, _, _ in } login: { _, _ in }
        .previewDisplayName("Bare")

      SheetView.Preview {
        AuthenticationView { _, _, _ in } login: { _, _ in }
      }
      .previewDisplayName("Sheet")
    }
    .configureForPreviews()
  }
}
#endif
