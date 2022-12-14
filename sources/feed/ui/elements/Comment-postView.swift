//	Created by Leopold Lemmermann on 07.11.22.

import AuthenticationUI
import ComposableArchitecture
import DatabaseService
import Errors
import LeosMisc
import SwiftUI

extension Comment {
  struct PostView: View {
    let projectID: Project.ID

    var body: some View {
      WithViewStore<ViewState, ViewAction, _>(store) { state in
        ViewState(currentUserID: state.account.id, hasiCloud: state.account.canPublish)
      } send: { action in
        switch action {
        case .loadCurrentUserID: return .account(.loadID)
        case let .postComment(comment): return .publicDatabase(.comments(.add(comment)))
        }
      } content: { vm in
        Render(isLoggedIn: vm.isLoggedIn, hasiCloud: vm.hasiCloud) { content in
          if let id = vm.currentUserID {
            await vm.send(.postComment(Comment(content: content, project: projectID, poster: id))).finish()
            // TODO: throw error here
          }
        }
        .task { await vm.send(.loadCurrentUserID).finish() }
      }
    }

    @EnvironmentObject private var store: StoreOf<MainReducer>

    init(projectID: Project.ID) { self.projectID = projectID }

    struct ViewState: Equatable {
      var currentUserID: User.ID?, hasiCloud: Bool
      var isLoggedIn: Bool { currentUserID != nil }
    }

    enum ViewAction { case loadCurrentUserID, postComment(Comment) }

    struct Render: View {
      let isLoggedIn: Bool
      let hasiCloud: Bool
      let postComment: (String) async throws -> Void

      var body: some View {
        if isLoggedIn {
          TextField.WithConfirm("ENTER_COMMENT_PROMPT", text: $content, confirmIsDisabled: content.count < 2) {
            await printError {
              do {
                try await postComment(content.trimmingCharacters(in: .whitespacesAndNewlines))
                content = ""
              } catch let error as DatabaseError where error.hasDescription { self.error = error }
            }
          }
          .textFieldStyle(.roundedBorder)
          .textCase(nil)
          .disabled(!hasiCloud, message: "SIGN_INTO_ICLOUD")
          .alert(isPresented: Binding(item: $error), error: error) {}
        } else {
          Button("SIGN_IN_TO_COMMENT") { isAuthenticating = true }
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .contentShape(Capsule())
            .popover(isPresented: $isAuthenticating) { AuthenticationView(service: authService) }
        }
      }

      @State private var content = ""
      @State private var isAuthenticating = false
      @State private var error: DatabaseError?
      @Dependency(\.authenticationService) private var authService
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct CommentPostView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Comment.PostView.Render(isLoggedIn: true, hasiCloud: true) { _ in }

      Comment.PostView.Render(isLoggedIn: false, hasiCloud: true) { _ in }
        .previewDisplayName("Not authenticated")

      Comment.PostView.Render(isLoggedIn: true, hasiCloud: false) { _ in }
        .previewDisplayName("No iCloud")
    }
    .padding()
  }
}
#endif
