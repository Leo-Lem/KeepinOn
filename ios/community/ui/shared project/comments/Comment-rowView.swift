//	Created by Leopold Lemmermann on 07.11.22.

import Concurrency
import Errors
import RemoteDatabaseService
import SwiftUI

extension Comment {
  func rowView() -> some View { RowView(self) }

  struct RowView: View {
    let comment: Comment

    var body: some View {
      VStack {
        if let poster = poster {
          Text(poster.label + ":")
            .font(.default(.headline))
            .foregroundColor(poster.color)
            .frame(maxWidth: .infinity, alignment: .leading)
        }

        Text(comment.content)

        Text(comment.timestamp.formatted(date: .complete, time: .shortened))
          .font(.default(.caption2))
          .frame(maxWidth: .infinity, alignment: .trailing)
          .foregroundColor(.gray)
      }
      .animation(.default, value: poster)
      .accessibilityElement(children: .ignore)
      .accessibilityLabel("A11Y_COMMENT")
      .accessibilityValue(comment.a11y(posterLabel: poster?.label))
      .if(canDelete) { $0
        .overlay(alignment: .topTrailing) {
          Button(action: delete) { Label("DELETE", systemImage: "xmark.octagon") }
            .imageScale(.large)
            .foregroundColor(.red)
            .labelStyle(.iconOnly)
            .buttonStyle(.borderless)
            .disabled(mainState.remoteDBService.status != .available, message: nil)
            .accessibilityLabel("DELETE")
        }
        .swipeActions(edge: .trailing) {
          Button(action: delete) { Label("DELETE", systemImage: "trash") }
            .disabled(mainState.remoteDBService.status != .available, message: nil)
            .tint(.red)
        }
      }
      .task {
        await loadPoster()
        tasks.add(mainState.remoteDBService.didChange.getTask(.high, operation: updatePoster))
      }
    }

    @EnvironmentObject private var mainState: MainState
    @State private var isDeleting = false
    @State private var poster: User?

    private let tasks = Tasks()

    init(_ comment: Comment) { self.comment = comment }
  }
}

private extension Comment.RowView {
  var canDelete: Bool { mainState.user != nil && mainState.user?.id == comment.poster }

  func delete() {
    guard let user = mainState.user, user.id == comment.poster else { return }

    Task(priority: .userInitiated) {
      isDeleting = true
      await printError {
        try await mainState.displayError {
          try await mainState.remoteDBService.unpublish(comment)
        }
      }
      isDeleting = false
    }
  }

  func updatePoster(_ change: RemoteDatabaseChange) async {
    switch change {
    case let .published(convertible):
      if let user = convertible as? User, user.id == comment.poster { poster = user }

    case let .unpublished(id, _):
      if let id = id as? User.ID, id == comment.poster { poster = nil }

    case let .status(status) where status != .unavailable: await loadPoster()
    case .remote: await loadPoster()
    default: break
    }
  }

  func loadPoster() async {
    do {
      poster = try await mainState.remoteDBService.fetch(with: comment.poster)
    } catch { print(error) }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct CommentsViewRow_Previews: PreviewProvider {
    static var previews: some View {
      List {
        Comment.RowView(.example)
      }
      .listStyle(.plain)
      .padding()
      .configureForPreviews()
    }
  }
#endif
