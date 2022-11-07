//	Created by Leopold Lemmermann on 07.11.22.

import SwiftUI

extension CommentsView {
  struct Row: View {
    let comment: Comment,
        deleteEnabled: Bool,
        delete: () async -> Void

    var body: some View {
      VStack {
        Text(
          (comment.postedBy?.name ?? String(localized: .init("ANONYMOUS_USER"))) + ":"
        )
        .font(.default(.headline))
        .foregroundColor(comment.postedBy?.color)
        .frame(maxWidth: .infinity, alignment: .leading)

        Text(comment.content)

        Text(comment.timestamp.formatted(date: .complete, time: .shortened))
          .font(.default(.caption2))
          .frame(maxWidth: .infinity, alignment: .trailing)
          .foregroundColor(.gray)
      }
      .if(deleteEnabled) { $0
        .overlay(alignment: .topTrailing) {
          Button(
            action: { deleteComment() },
            label: { Label("GENERIC_DELETE", systemImage: "xmark.octagon") }
          )
          .imageScale(.large)
          .foregroundColor(.red)
          .labelStyle(.iconOnly)
          .buttonStyle(.borderless)
        }
        .swipeActions(edge: .trailing) {
          Button(
            action: { deleteComment() },
            label: { Label("GENERIC_DELETE", systemImage: "trash") }
          )
          .tint(.red)
        }
      }
    }

    @State private var isDeleting = false

    init(
      _ comment: Comment,
      deleteEnabled: Bool,
      delete: @escaping () async -> Void
    ) {
      self.comment = comment
      self.deleteEnabled = deleteEnabled
      self.delete = delete
    }

    private func deleteComment() {
      Task(priority: .userInitiated) {
        isDeleting = true
        await delete()
        isDeleting = false
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct CommentsViewRow_Previews: PreviewProvider {
  static var previews: some View {
    List {
      Section("Without deleting") {
        CommentsView.Row(.example, deleteEnabled: false) {}
      }

      Section("With deleting") {
        CommentsView.Row(.example, deleteEnabled: true) {}
      }
    }
    .listStyle(.plain)
    .padding()
    .configureForPreviews()
  }
}
#endif
