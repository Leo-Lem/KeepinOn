// Created by Leopold Lemmermann on 14.12.22.

import DatabaseService
import LeosMisc
import Previews
import SwiftUI
import ComposableArchitecture

extension User {
  func detailView() -> some View { DetailView(self) }

  struct DetailView: View {
    let user: User

    var body: some View {
      WithViewStore<ViewState, ViewAction, _>(store) { state in
        ViewState(
          currentUserID: state.account.id,
          projects: state.publicDatabase.projects.convertibles(matching: projectsQuery),
          comments: state.publicDatabase.comments.convertibles(matching: commentsQuery)
        )
      } send: { action in
        switch action {
        case .loadCurrentUserID: return .account(.loadID)
        case .loadProjects: return .publicDatabase(.projects(.loadFor(query: projectsQuery)))
        case .loadComments: return .publicDatabase(.comments(.loadFor(query: commentsQuery)))
        }
      } content: { vm in
        Render(user, projects: vm.projects, comments: vm.comments, currentUserID: vm.currentUserID)
          .task {
            await vm.send(.loadCurrentUserID).finish()
            await vm.send(.loadProjects).finish()
            await vm.send(.loadComments).finish()
          }
      }
    }

    @EnvironmentObject private var store: StoreOf<MainReducer>
    private var projectsQuery: Query<SharedProject> { Query(\.owner, user.id, options: .init(batchSize: 5)) }
    private var commentsQuery: Query<Comment> { Query(\.poster, user.id, options: .init(batchSize: 5)) }
    
    init(_ user: User) { self.user = user }
    
    struct ViewState: Equatable { var currentUserID: User.ID?, projects: [SharedProject], comments: [Comment] }
    enum ViewAction { case loadCurrentUserID, loadProjects, loadComments }

    struct Render: View {
      let user: User
      let projects: [SharedProject]
      let comments: [Comment]
      let currentUserID: User.ID?

      var body: some View {
        List {
          Section("USER_PROJECTS") {
            ForEach(projects, content: SharedProject.PeekView.init)
              .replaceIfEmpty(with: "NO_PROJECTS_PLACEHOLDER")
          }

          Section("USER_COMMENTS") {
            ForEach(comments, content: Comment.RowView.init)
              .replaceIfEmpty(with: "NO_COMMENTS_PLACEHOLDER")
          }
        }
        .addHeader {
          HStack(alignment: .top) {
            user.avatarID.icon()
              .frame(width: 50)
              .foregroundColor(user.color)

            user.nameView()

            Spacer()

            if user.id != currentUserID {
              User.FriendActionMenu(user.id)
                .labelStyle(.iconOnly)
                .imageScale(.large)
                .font(.title)
            }
          }
          .padding(.horizontal)
        }
      }

      init(_ user: User, projects: [SharedProject], comments: [Comment], currentUserID: User.ID?) {
        (self.user, self.projects, self.comments, self.currentUserID) = (user, projects, comments, currentUserID)
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct UserDetailView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      User.DetailView.Render(
        .example, projects: [.example, .example, .example], comments: [.example, .example, .example],
        currentUserID: nil
      )
      .presentPreview(inContext: true)
      
      let user = User.example
      User.DetailView.Render(
        user, projects: [.example, .example, .example], comments: [.example, .example, .example],
        currentUserID: user.id
      )
      .presentPreview(inContext: true)
      .previewDisplayName("Current user is user")
    }
  }
}
#endif
