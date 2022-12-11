//	Created by Leopold Lemmermann on 07.11.22.

import Concurrency
import Errors
import LeosMisc
import SwiftUI

extension Comment {
  struct PostView: View {
    let projectID: Project.ID

    var body: some View {
      if mainState.authenticationState == .notAuthenticated {
        Button("SIGN_IN_TO_COMMENT") { isAuthenticating = true }
          .frame(maxWidth: .infinity, minHeight: 44)
          .background(Color.blue)
          .foregroundColor(.white)
          .clipShape(Capsule())
          .contentShape(Capsule())
          .popover(isPresented: $isAuthenticating, content: AuthenticationView.init)
      } else {
        VStack {
          TextField("ENTER_COMMENT_PROMPT", text: $text)
            .textFieldStyle(.roundedBorder)
            .textCase(nil)

          AsyncButton(indicatorStyle: .edge(.trailing), taskPriority: .userInitiated) {
            await postComment()
          } label: {
            Text("SEND")
              .frame(maxWidth: .infinity, minHeight: 44)
              .background(text.count < 2 || isDisabled ? Color.gray : .accentColor)
              .foregroundColor(.white)
              .clipShape(Capsule())
              .contentShape(Capsule())
          }
          .disabled(text.count < 2 || isDisabled)
        }
        .disabled(isDisabled, message: "SIGN_INTO_ICLOUD")
      }
    }

    @State private var isAuthenticating = false
    @State private var text = ""

    @EnvironmentObject private var mainState: MainState

    init(projectID: Project.ID) { self.projectID = projectID }
  }
}

private extension Comment.PostView {
  var isDisabled: Bool {
    if case .authenticatedWithoutiCloud = mainState.authenticationState { return true } else { return false }
  }

  @MainActor func postComment() async {
    await printError {
      guard case let .authenticated(user) = mainState.authenticationState else { return }

      try await mainState.displayError {
        try await mainState.publicDBService.insert(
          Comment(content: text.trimmingCharacters(in: .whitespacesAndNewlines), project: projectID, poster: user.id)
        )
        try await mainState.awardsService.postedComment()
      }

      self.text = ""
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct CommentPostView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Comment.PostView(projectID: Project.ID())
    }
    .padding()
    .configureForPreviews()
  }
}
#endif
