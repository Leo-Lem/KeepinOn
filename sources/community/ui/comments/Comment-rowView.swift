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
      .if(accountService.user?.id == comment.poster) { $0
        .swipeActions(edge: .trailing) {
          AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) { await delete() } label: {
            Label("DELETE", systemImage: "trash")
          }
          .tint(.red)
          .disabled(!accountService.canPublish)
        }
      }
      .alert(isPresented: Binding(item: $error), error: error) {}
      .task {
        await loadPoster()
        tasks["updatePoster"] = communityController.databaseService.handleEventsTask(.userInitiated, with: updatePoster)
      }
    }

    @State private var error: DatabaseError?
    
    @Persisted var poster: User?
    
    @EnvironmentObject private var communityController: CommunityController
    @EnvironmentObject private var accountService: AccountController
    
    private let tasks = Tasks()
    
    init(_ comment: Comment) {
      self.comment = comment
      _poster = Persisted(wrappedValue: nil, "\(comment.id)-poster")
    }
  }
}

private extension Comment.RowView {
  @MainActor func delete() async {
    await printError {
      guard accountService.user?.id == comment.poster && accountService.canPublish else { return }

      do {
        try await communityController.databaseService.delete(comment)
      } catch let error as DatabaseError where error.hasDescription {
        self.error = error
      }
    }
  }
}

private extension Comment.RowView {
  @MainActor func loadPoster() async {
    await printError {
      poster = try await communityController.databaseService.fetch(with: comment.poster)
    }
  }
  
  @MainActor func updatePoster(on event: DatabaseEvent) async {
      switch event {
      case let .inserted(type, id) where type == User.self && id as? User.ID == comment.poster:
        await loadPoster()
      case let .deleted(type, id) where type == User.self && id as? User.ID == comment.poster:
        poster = nil
      case let .status(status) where status == .unavailable:
        break
      case .status, .remote:
        await loadPoster()
      default:
        break
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
    
  }
}
#endif
