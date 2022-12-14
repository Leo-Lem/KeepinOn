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
      startLoading(for: project)
      
      tasks["updateItems"] = communityController.databaseService.handleEventsTask(.userInitiated) { event in
        if await communityController.updateElements(on: event, by: { $0.project == project.id}, into: commentsBinding) {
          startLoading(for: project)
        }
      }
    }
    .onChange(of: project, perform: startLoading)
  }
  
  @Persisted private var comments: LoadingState<Comment>
  private var commentsBinding: Binding<LoadingState<Comment>> {
    Binding(get: { comments }, set: { comments = $0 })
  }
  
  @EnvironmentObject private var communityController: CommunityController
  
  private let tasks = Tasks()
  
  init(_ project: SharedProject) {
    self.project = project
    _comments = Persisted(wrappedValue: .idle, "\(project.id)-comments")
  }
  
  private func startLoading(for project: SharedProject) {
    tasks["loadItems"] = Task(priority: .userInitiated) {
      await communityController
        .loadElements(query: .init(\.project, .equal, project.id, options: .init(batchSize: 5)), into: commentsBinding)
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
      
    }
  }
#endif
