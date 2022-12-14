// Created by Leopold Lemmermann on 14.12.22.

import SwiftUI

extension User {
  func nameView() -> some View { NameView(self) }

  struct NameView: View {
    let user: User

    var body: some View {
      VStack(alignment: .leading) {
        Text(user.label + " ")
          .bold()
          .font(.default(.title2))
          .lineLimit(1)
          .foregroundColor(user.color)

        Text(idLabel)
          .lineLimit(1)
      }
      .accessibilityElement(children: .ignore)
      .accessibilityValue("A11Y_USER \(user.label) \(idLabel)")
    }

    private var idLabel: String { "@\(user.id)".prefix(10) + ("@\(user.id)".count > 10 ? "..." : "") }

    init(_ user: User) { self.user = user }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct UserNameView_Previews: PreviewProvider {
  static var previews: some View {
    User.example.nameView()
  }
}
#endif
