//	Created by Leopold Lemmermann on 25.10.22.

import SwiftUI
import Concurrency

struct CommentsView: View {
  let state: LoadingState<Comment>,
      canDelete: (Comment) -> Bool,
      delete: (Comment) async  -> Void

  var body: some View {
    switch state {
    case let .loading(comments):
      ForEach(comments.sorted(by: \.timestamp)) { comment in
        Row(comment, deleteEnabled: canDelete(comment)) {
          await delete(comment)
        }
      }

      ProgressView()
        .frame(maxWidth: .infinity)
    case let .loaded(comments):
      ForEach(comments.sorted(by: \.timestamp)) { comment in
        Row(comment, deleteEnabled: canDelete(comment)) {
          await delete(comment)
        }
      }
    case let .loaded(comments) where comments.isEmpty:
      Text("NO_COMMENTS_PLACEHOLDER")
    #if DEBUG
      case let .failed(error):
        Text(error?.localizedDescription ?? "")
    #endif
    default:
      ProgressView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct CommentsView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      CommentsView(state: .idle) { _ in .random() } delete: { _ in }
        .previewDisplayName("Idle")

      List {
        CommentsView(
          state: .loading([.example, .example])
        ) { _ in .random() } delete: { _ in }
      }
      .listStyle(.plain)
      .previewDisplayName("Loading")

      List {
        CommentsView(
          state: .loaded([.example, .example, .example])
        ) { _ in .random() } delete: { _ in }
      }
      .listStyle(.plain)
      .previewDisplayName("Loaded")

      CommentsView(state: .failed(nil)) { _ in .random() } delete: { _ in }
        .previewDisplayName("Failed")
    }
    .padding()
    .configureForPreviews()
  }
}
#endif
