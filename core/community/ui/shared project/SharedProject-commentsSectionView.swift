//	Created by Leopold Lemmermann on 25.10.22.

import Concurrency
import RemoteDatabaseService
import SwiftUI
import LeosMisc

extension SharedProject {
  func commentsSectionView(comments: LoadingState<Comment> = .idle) -> some View {
    CommentsSectionView(self, comments: comments)
  }
}

struct CommentsSectionView: View {
  let project: SharedProject

  var body: some View {
    Section {
      switch comments {
      case let .loading(comments), let .loaded(comments):
        ForEach(comments.sorted(by: \.timestamp), content: Comment.RowView.init)
          .replaceIfEmpty(with: "NO_COMMENTS_PLACEHOLDER")
        if self.comments.isLoading { ProgressView().frame(maxWidth: .infinity) }

      #if DEBUG
        case let .failed(error): Text(error?.localizedDescription ?? "")
      #endif
      default: ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    } header: {
      Text("COMMENTS_HEADER")
    } footer: {
      Comment.PostView(projectID: project.id)
      .padding(.vertical)
    }
    .animation(.default, value: comments)
    .task {
      loadComments()
      tasks.add(mainState.remoteDBService.didChange.getTask(operation: updateComments))
    }
  }

  @EnvironmentObject private var mainState: MainState
  @State private var comments: LoadingState<Comment>

  private let tasks = Tasks()

  init(
    _ project: SharedProject,
    comments: LoadingState<Comment> = .idle
  ) {
    self.project = project
    _comments = State(initialValue: comments)
  }
}

private extension CommentsSectionView {
  func loadComments() {
    tasks["loadingComments"] = Task(priority: .userInitiated) {
      do {
        try await mainState.displayError {
          let query = Query<Comment>(\.project, .equal, self.project.id, options: .init(batchSize: 5))
          for try await comments in mainState.remoteDBService.fetch(query) {
            self.comments.add(comments)
          }

          comments.finish {}
        }
      } catch { comments.finish { throw error } }
    }
  }

  func updateComments(on change: RemoteDatabaseChange) async {
    switch change {
    case let .published(convertible):
      if
        let item = convertible as? Comment,
        let index = comments.wrapped?.firstIndex(where: { $0.id == project.id })
      {
        comments.wrapped?[index] = item
      }
      comments.finish {}

    case let .unpublished(id, _):
      if
        let id = id as? Comment.ID,
        let index = comments.wrapped?.firstIndex(where: { $0.id == id })
      {
        comments.wrapped?.remove(at: index)
      }
      
    case let .status(status) where status != .unavailable: loadComments()
    case .remote: loadComments()
    default: break
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct CommentsListView_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        CommentsSectionView(.example, comments: .idle)
          .previewDisplayName("Idle")

        List {
          CommentsSectionView(.example, comments: .loading([.example, .example]))
        }
        .listStyle(.plain)
        .previewDisplayName("Loading")

        List {
          CommentsSectionView(.example, comments: .loaded([.example, .example, .example]))
        }
        .listStyle(.plain)
        .previewDisplayName("Loaded")

        CommentsSectionView(.example, comments: .failed(nil))
          .previewDisplayName("Failed")
      }
      .padding()
      .configureForPreviews()
    }
  }
#endif
