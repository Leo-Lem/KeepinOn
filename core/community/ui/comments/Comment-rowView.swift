//	Created by Leopold Lemmermann on 07.11.22.

import CloudKitService
import Concurrency
import Errors
import LeosMisc
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
        .swipeActions(edge: .trailing) {
          AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) { await delete() } label: {
            Label("DELETE", systemImage: "trash")
          }
          .tint(.red)
          .disabled(!mainState.authenticationState.hasiCloud, message: nil)
        }
      }
      .task {
        await loadPoster()
        tasks["updatePoster"] = Task(priority: .background) { await updatePoster() }
      }
    }

    @Persisted var poster: User?
    @State private var tasks = Tasks()
    @EnvironmentObject var mainState: MainState

    init(_ comment: Comment) {
      self.comment = comment
      _poster = Persisted(wrappedValue: nil, "\(comment.id)-poster")
    }
  }
}

private extension Comment.RowView {
  var canDelete: Bool {
    if case let .authenticated(user) = mainState.authenticationState {
      return user.id == comment.poster
    } else {
      return false
    }
  }
  
  @MainActor func delete() async {
    await printError {
      guard canDelete else { return }

      try await mainState.displayError {
        try await mainState.publicDBService.delete(comment)
      }
    }
  }
}

private extension Comment.RowView {
  @MainActor func loadPoster() async {
    await printError {
      poster = try await mainState.publicDBService.fetch(with: comment.poster)
    }
  }
  
  @MainActor func updatePoster() async {
    for await event in mainState.publicDBService.events {
      switch event {
      case let .inserted(type, id) where type == User.self:
        if id as? User.ID == comment.poster { await loadPoster() }
      case let .deleted(type, id) where type == User.self:
        if id as? User.ID == comment.poster { poster = nil }
      case let .status(status) where status == .unavailable:
        break
      case .status, .remote:
        await loadPoster()
      default:
        break
      }
    }
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
