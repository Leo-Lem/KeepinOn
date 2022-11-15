//	Created by Leopold Lemmermann on 27.10.22.

import SwiftUI

struct EditAccountView: View {
  let user: User

  let logout: () -> Void,
      update: (User) async throws -> Void

  var body: some View {
    VStack {
      HStack {
        Text(user.label + " ").font(.default(.title1))
          + Text(
            user.idLabel.prefix(10) +
              (user.idLabel.count > 10 ? "..." : "")
          ).font(.default(.subheadline))

        Spacer()

        Button(action: logout) {
          Label("ACCOUNT_LOGOUT", systemImage: "person.fill.xmark")
            .labelStyle(.titleAndIcon)
        }
        .buttonStyle(.borderedProminent)
      }
      .bold()
      .foregroundColor(user.color)
      .padding()
      .frame(maxWidth: .infinity)

      Form {
        Section("ACCOUNT_CHANGE_DISPLAYNAME") {
          TextField(user.name ??? String(localized: .init("ACCOUNT_CHANGE_DISPLAYNAME")), text: $name)
            .textFieldStyle(.roundedBorder)
            .textCase(nil)

          Button {
            Task(priority: .userInitiated) {
              do {
                var user = user
                user.name = name
                try await update(user)
                name = ""
              } catch {}
            }
          } label: {
            Text("GENERIC_CONFIRM")
              .frame(maxWidth: .infinity, minHeight: 44)
              .background(name.count < 3 ? Color.gray : Color.accentColor)
              .foregroundColor(.white)
              .clipShape(Capsule())
              .contentShape(Capsule())
          }
          .disabled(name.count < 3)
        }

        Section("ACCOUNT_SELECT_COLOR") {
          $colorID.selectionGrid
            .onChange(of: colorID) { newValue in
              Task(priority: .userInitiated) {
                do {
                  var user = user
                  user.colorID = newValue
                  try await update(user)
                } catch {
                  colorID = user.colorID
                }
              }
            }
        }
      }
      .scrollContentBackground(.hidden)
    }
  }

  @State private var name = ""
  @State private var colorID: ColorID

  init(user: User, logout: @escaping () -> Void, update: @escaping (User) async throws -> Void) {
    self.user = user
    self.logout = logout
    self.update = update
    colorID = user.colorID
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct EditAccountView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      EditAccountView(user: .example) {} update: { _ in }
        .previewDisplayName("Bare")

      SheetView.Preview {
        EditAccountView(user: .example) {} update: { _ in }
      }
      .previewDisplayName("Sheet")
    }
    .configureForPreviews()
  }
}
#endif
