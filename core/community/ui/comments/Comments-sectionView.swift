//	Created by Leopold Lemmermann on 25.10.22.

import Concurrency
import CloudKitService
import Errors
import LeosMisc
import SwiftUI

extension SharedProject {
  func commentsSectionView() -> some View { CommentsSectionView(self) }
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
      default:
        ProgressView().frame(maxWidth: .infinity)
      }
    } header: {
      Text("COMMENTS_HEADER")
    } footer: {
      Comment.PostView(projectID: project.id)
        .padding(.vertical)
    }
    .animation(.default, value: comments)
    .onAppear {
      tasks["loadComments"] = Task(priority: .userInitiated) { await loadComments(for: project) }
      tasks["updateComments"] = Task(priority: .background) { await updateComments() }
    }
    .onChange(of: project) { newProject in
      tasks["loadComments"] = Task(priority: .userInitiated) { await loadComments(for: newProject) }
    }
  }
  
  @Persisted private var comments: LoadingState<Comment>
  @State private var tasks = Tasks()
  @EnvironmentObject private var mainState: MainState

  init(_ project: SharedProject) {
    self.project = project
    _comments = Persisted(wrappedValue: .idle, "\(project.id)-comments")
  }
}

private extension CommentsSectionView {
  @MainActor func loadComments(for project: SharedProject) async {
    do {
      try await mainState.displayError {
        let query = Query<Comment>(\.project, .equal, self.project.id, options: .init(batchSize: 5))
        
        for try await comments in try await mainState.publicDBService.fetch(query) {
          self.comments.add(comments)
        }

        comments.finish {}
      }
    } catch { comments.finish { throw error } }
  }

  @MainActor func updateComments() async {
    await printError {
      for await event in mainState.publicDBService.events {
        switch event {
        case let .inserted(type, id) where type == Comment.self:
          if
            let id = id as? Comment.ID,
            let comment: Comment = try await mainState.fetch(with: id, fromPrivate: false),
            comment.project == project.id
          {
            mainState.insert(comment, into: &comments.wrapped)
          }
        case let .deleted(type, id) where type == Comment.self:
          if let id = id as? Comment.ID { mainState.remove(with: id, from: &comments.wrapped) }
        case let .status(status) where status == .unavailable:
          break
        case .status, .remote:
          tasks["loadComments"] = Task(priority: .high) { await loadComments(for: project) }
        default:
          break
        }
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct CommentsListView_Previews: PreviewProvider {
    static var previews: some View {
      List {
        CommentsSectionView(.example)
      }
      .configureForPreviews()
    }
  }
#endif
