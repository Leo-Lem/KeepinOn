// Created by Leopold Lemmermann on 17.12.22.

import LeosMisc
import SwiftUI

extension User {
  struct CommentsView: View {
    let currentUserID: User.ID

    var body: some View {
      WithConvertiblesViewStore(
        matching: .init(\.poster, currentUserID, options: .init(batchSize: 5)),
        from: \.publicDatabase.comments,
        loadWith: .init { MainReducer.Action.publicDatabase(.comments($0)) },
        content: Render.init
      )
    }

    struct Render: View {
      let comments: [Comment]

      var body: some View {
        List(comments) {
          $0.rowView()
          // TODO: group comments by project
        }
        .replace(if: comments.isEmpty, placeholder: "NO_COMMENTS_PLACEHOLDER")
      }

      init(_ comments: [Comment]) { self.comments = comments }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct UserCommentsView_Previews: PreviewProvider {
  static var previews: some View {
    User.CommentsView.Render([])
      .presentPreview(inContext: true)

    User.CommentsView.Render([.example, .example, .example])
      .presentPreview(inContext: true)
  }
}
#endif
