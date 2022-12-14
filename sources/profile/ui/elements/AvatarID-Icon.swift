// Created by Leopold Lemmermann on 14.12.22.

import SwiftUI

extension User.AvatarID {
  func icon() -> some View { Icon(self) }
  
  struct Icon: View {
    let avatarID: User.AvatarID
    
    var body: some View {
      Image(systemName: avatarID.systemName)
        .resizable()
        .scaledToFit()
        .padding(10)
        .aspectRatio(1 / 1, contentMode: .fit)
        .overlay { Circle().stroke(lineWidth: 3).scaledToFill() }
        .padding(5)
    }
    
    init(_ avatarID: User.AvatarID) { self.avatarID = avatarID }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct AvatarIcon_Previews: PreviewProvider {
  static var previews: some View {
    User.AvatarID.turtle.icon()
      .frame(width: 50)
  }
}
#endif
