// Created by Leopold Lemmermann on 18.12.22.

import SwiftUI

extension User {
  func peekView() -> some View { PeekView(self) }
  
  struct PeekView: View {
    let user: User?
    
    var body: some View {
      HStack {
        (user ?? .example).avatarID.icon()
          .frame(width: 50)
          .foregroundColor(user?.color)
        
        (user ?? .example).nameView()
      }
      .if(user == nil) { $0.redacted(reason: .placeholder) }
    }
    
    init(_ user: User?) { self.user = user }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct UserPeekView_Previews: PreviewProvider {
  static var previews: some View {
    User.PeekView(.example)
    User.PeekView(nil).previewDisplayName("Placeholder")
  }
}
#endif
