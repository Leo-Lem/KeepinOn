//  Created by Leopold Lemmermann on 22.11.22.

import SwiftUI

extension Friendship {
  struct RowView: View {
    let friendID: User.ID

    var body: some View {
      WithConvertibleViewStore(
        with: friendID,
        from: \.publicDatabase.users,
        loadWith: .init { MainReducer.Action.publicDatabase(.users($0)) },
        content: Render.init
      )
    }
    
    struct Render: View {
      let friend: User?
      
      var body: some View {
        HStack {
          User.PeekView(friend)
            
          Spacer()
          
          User.FriendActionMenu(friend?.id ?? User.example.id)
            .labelStyle(.iconOnly)
            .imageScale(.large)
            .font(.default(.title1))
            .disabled(friend == nil)
        }
        .onTapGesture {
          if let friend { present(MainDetail.user(friend)) }
        }
      }
      
      @Environment(\.present) private var present
      
      init(_ friend: User?) { self.friend = friend }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct UserFriendRowView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Friendship.RowView.Render(.example)
      
      Friendship.RowView.Render(nil).previewDisplayName("Placeholder")
      
      List([User.example, .example, .example], rowContent: Friendship.RowView.Render.init)
        .previewDisplayName("List")
    }
    .presentPreview()
  }
}
#endif
