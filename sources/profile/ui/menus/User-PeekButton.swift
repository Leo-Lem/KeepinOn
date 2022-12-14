// Created by Leopold Lemmermann on 15.12.22.

import SwiftUI

extension User {
  func peekButton() -> some View { PeekButton(self) }

  struct PeekButton: View {
    let user: User

    var body: some View {
      Button { isPresentingUser = true } label: {
        user.avatarID.icon()
          .foregroundColor(user.color)
      }
      .buttonStyle(.borderless)
      .popover(isPresented: $isPresentingUser) {
        HStack {
          user.peekView()
          
          Spacer()
          
          User.FriendActionMenu(user.id)
            .labelStyle(.iconOnly)
            .imageScale(.large)
            .font(.default(.title1))
        }
        .padding()
        .presentationDetents([.fraction(0.1)])
      }
    }

    @State private var isPresentingUser = false

    init(_ user: User) { self.user = user }
  }
}

// MARK: - (PREVIEWS)

struct UserPeekButton_Previews: PreviewProvider {
  static var previews: some View {
    User.PeekButton(.example).frame(height: 50)
      .presentPreview()
  }
}
